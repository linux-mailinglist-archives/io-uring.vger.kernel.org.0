Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE0F16AA0D
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgBXP1X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:27:23 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39503 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgBXP1X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:27:23 -0500
Received: by mail-il1-f195.google.com with SMTP id f70so8025840ill.6
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DvvfESwm+sGWj3YYhDZhaIOOXynjcOEAp/pnclvgUIw=;
        b=ViWKx2uLl1trcB3uCNdnbbNNGZ7xmOCgyDHFo2sWcwakMSD7u+LxvHZ4d7G1+tmgjz
         a9QeymH18R23wV0xfaCj/PSiaWqHQursn1Cqz0CYMy57SjKhsj2jcEpHCR/U19A27OOb
         MbKlERMRgAJaRE57+WqXDobGGSvuoTGJ115T3aeSEMbdFjP4io4004jpyNZucOEMAvky
         6q2j2qGuNoVUCBXix5vS15D8uqN/nXVAww3z3drTfoHqO2u2bk0LAfYN3sZaI5DhEMQb
         qy5TrY0LCpgE67HFIOK0DoURBJTVqMStWQcB1buW+G63ByqhfXepVpprtE7Z7FFVZRkA
         mlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DvvfESwm+sGWj3YYhDZhaIOOXynjcOEAp/pnclvgUIw=;
        b=TM6so44h0yzQeJqXDMODJkPq+QbAyavI+MkY9LlLCN68pa5GHxB3lxzpQLegdjfnEb
         iNmmUs2sE/se6O3bSWX6xu9BP65zSdz0raXXDNdeA4z450vXUFFbB/LhpXDlDk6X9Rlr
         LnO0qjhqIHK/aypJfXEWrbj1/ItVH/z2wXAcc8Mo8XrjyzPMm3F5T7ZNp5TZei/9oAp+
         f1lAtJqjMf4xHjevq4HdEtYMxSiXHRUO+/DJlvYQPmKrMY8Jx7HyP5uPsnMi4+B/L2II
         aGpzdMqpG2i/gOd3ZxA3GF3QjalWmSxB2cJiRPh2WmlfRnO+U40L5HCCdcHRPnM+yrkH
         +GUQ==
X-Gm-Message-State: APjAAAVIJP6UPKXV5eJGzBEQg9bmncrg1XC+lg6M9d+eI88rwcCE4rma
        bYK/lBOiYNc8HQRwB+1jbOwj/pDgumw=
X-Google-Smtp-Source: APXvYqwCQkAky39+erMjR8/wi5UIFbyCN/LIT7HTfad9ZnFS0fTD12dpLDjOj17+1Q77VGBWLAkOTA==
X-Received: by 2002:a92:ad0b:: with SMTP id w11mr60883593ilh.241.1582558042442;
        Mon, 24 Feb 2020 07:27:22 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x62sm4393424ill.86.2020.02.24.07.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:27:21 -0800 (PST)
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
Date:   Mon, 24 Feb 2020 08:27:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 2:15 AM, Pavel Begunkov wrote:
> It seems no opcode may return -EAGAIN for non-blocking case and expect
> to be reissued. Remove retry code from io_wq_submit_work().

There's actually a comment right there on how that's possible :-)

Normally, for block IO, we can wait for request slots if we run out.
For polled IO, that isn't possible since the task itself is the one
that will find completions and hence free request slots as well. If
the submitting task is allowed to sleep waiting for requests that it
itself are supposed to find and complete, then we'd hang. Hence we
return -EAGAIN for that case, and have no other choice for polled
IO than to retry.

-- 
Jens Axboe

