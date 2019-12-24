Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990CC129D32
	for <lists+io-uring@lfdr.de>; Tue, 24 Dec 2019 05:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLXEEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Dec 2019 23:04:50 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:50337 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfLXEEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Dec 2019 23:04:50 -0500
Received: by mail-pj1-f45.google.com with SMTP id r67so652792pjb.0
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2019 20:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OlwbwYhuOKaDGOvpdsdJwy7GnE3ZsTVTi80DGSMsYLg=;
        b=KRij/4a3YAbckLbQCg88goIntchIHm5P/c8ksWw0udaVg5e7luJLLR3nE+OM5N3iAj
         5CRjP3uDm/Xr3LaDNfcM7PYwap6nZO98V5eIuyRE+y6ccTruzhONn/C+89x2zGH7QVdv
         nWR+AtJq4ZFs0uHxXwe4mjICTnORB5Jdf3vrL9JOzn+b0NBfCCtpeTs4HIP4Kq0gN+iP
         8Ioo27+smLyMLRxXrBqJCCBbDoq8v3W4Ek+tq++yg4H1NCjAodqtAfFqx9W1MDhPUF6N
         yylnVsN/1jmsHdPrmrQa9K/xRBVniQsE+UVvcRb/ZdJp4JYUDv2BA6TiAAAp1e5fCEco
         A94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OlwbwYhuOKaDGOvpdsdJwy7GnE3ZsTVTi80DGSMsYLg=;
        b=rahYbEgHxyvFiHQViiz/Z8vWgaXHivlaRY8XsmTBc3NrH30zBPcUYKj5PRj0mq/Bnr
         yBKrLVNcAohorcVj14Q4cX/dpBuLy6V3P4Td4FRBas2shIrledqSchegr1QwZVBlTDhS
         W30WUEfmz8sW6sRUwdVgoJzm+3v6FIA4XoBPwjNydsfFFfvtbEes3Sf2thlx4S58nkRC
         YhEiGlAW1jv5sv+JCI3bXf2CCowJrge07AafOv8XYUUJbud+oj9FONUI1q9pPUcqQPUb
         VqFWEoWD1f4Nw748MMXvKSM+LOInqb4O2uLVCNcLQx7vVUxqeRzIeNNS6XqweDgTO3Jg
         09fg==
X-Gm-Message-State: APjAAAVn+1x167YaxSaxQXgbFsAW8aA17Yy4Rlek30MBEZkxaNgyncH7
        XyQ1sMEQUI4akhlS9nZe0Sy+CisEcRY=
X-Google-Smtp-Source: APXvYqwhTs0yr1/gh26Qs5nvKyQKVmSpv5UZy1MluoDchzcUBHGCQMqFJ45ojYZSP9DrWhi6Zv5hTA==
X-Received: by 2002:a17:90a:db0b:: with SMTP id g11mr3211849pjv.140.1577160289795;
        Mon, 23 Dec 2019 20:04:49 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1225? ([2620:10d:c090:180::5b7e])
        by smtp.gmail.com with ESMTPSA id l14sm23388030pgt.42.2019.12.23.20.04.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 20:04:49 -0800 (PST)
Subject: Re: [PATCHSET] Cleanup io_uring sqe handling
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
References: <20191220174742.7449-1-axboe@kernel.dk>
Message-ID: <01c61b91-0d4f-caac-17cc-982b6fd7eacb@kernel.dk>
Date:   Mon, 23 Dec 2019 21:04:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/20/19 10:47 AM, Jens Axboe wrote:
> This series contains some prep work, then two patches that once and for
> all cleanup the sqe handling. After this patchset, the prep and issue
> handling is fully split, so each opcode has a prep handler that is called
> in the same way, and an issue handler that doesn't call the prep handler.
> 
> The sqe pointer is removed from io_kiocb, so there cannot be any
> accidental dereference after we've done prep. Prep is always done in the
> original context, so we can have no reuse issues either.
> 
> I've rebased for-5.6/io_uring to have this series first, so this series
> applies on top of io_uring-5.5. Ideally we'd put this into 5.5, but...
> 
> In any case, please take a look, I think this is a massive improvement
> in terms of verifying that we're doing the right thing.
> 
>  fs/io_uring.c | 690 ++++++++++++++++++++++++++------------------------
>  1 file changed, 355 insertions(+), 335 deletions(-)

I've done various testing and everything seems to work just fine, no
issues found.

I'm tempted to push this to 5.5-rc4. It's a bit big, but I do think the
end result is much cleaner and we'll be better of for it.

-- 
Jens Axboe

