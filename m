Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68D8119C3A
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLJWRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 17:17:37 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35072 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfLJWRh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 17:17:37 -0500
Received: by mail-pj1-f68.google.com with SMTP id w23so7974462pjd.2
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 14:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Jyp0gEgRT+QMIhva6MDXaT4zVdr3DGjZilX1I5T6t4=;
        b=oUgYOrwwH9fxQ+00o1CFJs+LGD5HNQ8SbYgLUqmxXgykjCnWhz3G0nDhGXiv0ltMJX
         tNs0niIizlMMtLQI4VDm7lRNXzLb+4Qq2g/hq2jg/wtOlEoSgAeLeJutQO/fpCMQY3A9
         0U6KHcjRGxixjbUgbfhWC5HXR4atoR88kV85NOU9kQSefpyrI64pucqQK0K6MGzvubsO
         DnwxI1oc5WeMXwdkgP06EERmIXOf9xTLxxcMGBaHwVS+NFEZUaEddhdGNuIM91BmAWDR
         28POUbb83ZmZpd9W5CNEV5M71RQvh0Lj0EDFmaK8ZpGDgLxXFHU5FIrGOC8OD29syKRN
         CVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Jyp0gEgRT+QMIhva6MDXaT4zVdr3DGjZilX1I5T6t4=;
        b=cMOLU2A1keU+B8qr6IshTmiSlIAMJQRjFsnY+EIrAVovIHEMnu88K/pEeimRBkOnzo
         Ww8tiTNNA2OcTee8I5XdZs7g1kODa++uQiT98cYrvhA7XE0QnJNLPO7ogtly8BRk3J58
         SMN/rDuRvO1rMPQU0GRxwwDbuwlcDjxz0rKjF1viQVKsvGAqqKV0uMe4fSsc4/oFKCX/
         i/7jwFPhZ+dVaMIvCUt509aNSdOQrjCdy+2TEUUiNdna/yRE1uti0U7qzQaDaSQrAyoW
         k9T7Y9CcyQmqGW0aRecOcEWqMCSLbC0t8vxJG1tR+krDJNESzPZlnHhw5bVqPN+leu63
         GCGA==
X-Gm-Message-State: APjAAAV08sAArk4NI7P8j/LtXi6nxxpSDMUSQeXtoPzQvnerOnS2Q7dm
        DTm3tCFT49bF5ESvA31Xl4kP/g==
X-Google-Smtp-Source: APXvYqymAe8OXanODm02CqDCTtYdNwi2JybaQDieequ7hMJQVS4gzacyYVvZHxzVXIim46cySs1Oxg==
X-Received: by 2002:a17:90a:2664:: with SMTP id l91mr8205853pje.45.1576016256209;
        Tue, 10 Dec 2019 14:17:36 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1215? ([2620:10d:c090:180::4a7a])
        by smtp.gmail.com with ESMTPSA id j7sm14266pgn.0.2019.12.10.14.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:17:35 -0800 (PST)
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
 <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
 <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>
 <75ef6963-a9d7-33ef-cfdd-9770c09fc266@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a906f3c4-3b26-6c34-b749-f5561e14332a@kernel.dk>
Date:   Tue, 10 Dec 2019 15:17:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <75ef6963-a9d7-33ef-cfdd-9770c09fc266@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/19 2:28 PM, Pavel Begunkov wrote:
> Remembered my earlier comment. If the intention is to set HARDLINK,
> must it go with REQ_F_LINK? And if not, is it ever valid to set
> them both?

IOSQE_IO_HARDLINK implies IOSQE_IO_LINK, it's the same behavior, just
doesn't sever if we get a negative completion result.

> That's not like there is a preference, but as it affects userspace,
> it'd be better to state it clearly and make code to check it.

Agree!

-- 
Jens Axboe

