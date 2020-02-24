Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31A616AA1F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBXPat (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:30:49 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36258 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBXPat (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:30:49 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so8046874iln.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xBZQai2ypBGztA5V4HlrCoK7ELidZqRTkAFySZ9u2JE=;
        b=GKY26CD9QqlYK/lj8QqHOxfXoQAoSwZWYfs/TsOJIdrohxnmEB/knrYp3IDcjWfl74
         P75INj5yijQA877g4d+Kn5lq1+zNobE3HESRCDo6CW24gL5JfFzVQbNRFcWHybUP5Xir
         b+VpfXXd9C/QlGp/LhaFWVDFD9NEyVsB2aHQOhZsl8jW+/wVi1a7iKenwW9M5iomwj92
         W1plwIDx300tiBL8iz4wlb/E8zYsHrIxKX87PsuvuHJ4+2FBu6KT+fN7Q1FZ0H5xecdY
         e1+bvXvnOSAqm75L44Q1n2mcXpRH1elx+zQ1gaOwqtRBbqykWWHXOIglNAZklBXSzV91
         4NlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xBZQai2ypBGztA5V4HlrCoK7ELidZqRTkAFySZ9u2JE=;
        b=TRbR9jtgm2MckcF4F6VBtnD8M8vm6XqQgtAs4xk8MO4h5ZhbTuff/Qjvc1nYkLHXYK
         iH/mjX2+adTpsK61qXiKIZYvxyEU1Rqg1f5DaOZMG0XI3FokvPCyONCcofa26/MKIhUZ
         H8fFzypmRV4wbA0ueq8cO8E/gXHqXw1y4XDT1lnZDcKdbCSdEqn7vCIggp/uPkUXu1HL
         9pJc1K5s3pUt6Zls9aJ2Y9rAEcQoytPHMffpzb77FhrWSWBlm7suCdRSdCe4bD+zljd+
         Xmmzf121e/eRNpK8npnAlWLnqPpNYtd9TkMv2JBmj7RxxyCoqJrByBoyXB1F6RMGjDQb
         T5dQ==
X-Gm-Message-State: APjAAAXHfyi+zHoQx6FZPVBvfByBbFnnFOfccPYZ4EXQgosr6KuB7xW4
        1mB27scEXIqdSDvFGGT9OhKiIuyg0sg=
X-Google-Smtp-Source: APXvYqyWVuWZKe7US9aH+tt2bicozJevX9EH1x6UUY/dr6beI3WPIkoEX1dGqpgPIIEpx7WDWXMebw==
X-Received: by 2002:a92:af46:: with SMTP id n67mr61890660ili.195.1582558247849;
        Mon, 24 Feb 2020 07:30:47 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v5sm4422190ilg.73.2020.02.24.07.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:30:46 -0800 (PST)
Subject: Re: [PATCH v3 0/3] async punting improvements for io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582530396.git.asml.silence@gmail.com>
 <4775cbc6-3ec1-a09b-c8a1-8b34f5a30360@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c0ca9a98-e97f-0431-33f2-db7fd05cbe8d@kernel.dk>
Date:   Mon, 24 Feb 2020 08:30:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4775cbc6-3ec1-a09b-c8a1-8b34f5a30360@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 2:17 AM, Pavel Begunkov wrote:
> On 24/02/2020 11:30, Pavel Begunkov wrote:
>> *on top of for-5.6*
> 
> Jens, let me know if this and the splice patchset should be rebased onto
> your poll branch.

Since those are both ready at this point, I think we should queue
those up first and I'll rebase on top of that.

-- 
Jens Axboe

