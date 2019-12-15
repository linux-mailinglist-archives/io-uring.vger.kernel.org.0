Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1191F11F65A
	for <lists+io-uring@lfdr.de>; Sun, 15 Dec 2019 06:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfLOFmS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Dec 2019 00:42:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46440 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfLOFmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Dec 2019 00:42:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id y14so3757293pfm.13
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2019 21:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9HhPA8l94IXF/EFFgYeMxKbVnLjSYDFR2r7OBxJtk6I=;
        b=no4ycIihm5T2BbxlGXQkOjXKRlSKyase0t5W8Vkb99fEUq9OJGF9hOTlyxLWnoKnu3
         MlcaQsF+0kQSzyWfzCq1fLEcB/TLhNL/a13iji9J1qT8EYggNo9RyEdACBnyuu1FB/l5
         se2Qqgt5uzfsLdpi7QviGZUzHSR0zEtqfuPi+IXmIiWOxORbWTlDxyZGq1j8VvDAVz9O
         8alMm6XtHjQBEEjQLElaoFlAJAD439XIFMDc7UHXQbkuFmWf8nL/63WmMTYTtADALdBp
         Go77+dnLNc+L6yaUZ1NuiX/Leve+UxR1mJk8xbDSILVY4FXG0+nsg0tB86XDwRaH0wDJ
         js8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9HhPA8l94IXF/EFFgYeMxKbVnLjSYDFR2r7OBxJtk6I=;
        b=nfyPuyIRiSZhhSKv3bmwREOAR1OpCd/FdtC+FDSdrrF9IwbXCKUg/ILVa3QvdWWvlz
         kV6AR5JmcMHhtZZVDwoW2uz4RBw40xu9UzVf/l9z/ylrl/7MvvaHb5fsyxtg23WRwIKa
         1oxT+pbPV39yyhzvopHLkNLZdz4eFiws90S7adx6H6Wl1YbFZ4vnISCt3uHA3g9KMGU9
         lZb50GHzmUqLjIMHdMtzoUO0KW+Sh6UbLN2nc97/+GebMkbtdo0nituGKXIxUdo9ojwd
         +YuS2cMs3Dj8MYBxUbawHMseBpat1pB8Qzoy54tIkyXzjrtBJMnnZOTBcgTUXNuejn08
         mzvA==
X-Gm-Message-State: APjAAAVEeEzuOw506xfsPfkUCiD9ze+suknIeodWoG+oB3L37TBdsj7E
        QkqUHhOv4pBUBzRHcQzCo0KRIQ==
X-Google-Smtp-Source: APXvYqzjCjmixrJYCSMvdiMgO/BAt0dJYqSQtexLM8Psn2m+HbCN+l4SjeOD1vixOJG/pvDDqktDhQ==
X-Received: by 2002:a62:e50d:: with SMTP id n13mr8973600pff.201.1576388537187;
        Sat, 14 Dec 2019 21:42:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id j3sm17427875pfi.8.2019.12.14.21.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 21:42:16 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
Message-ID: <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
Date:   Sat, 14 Dec 2019 22:42:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/19 11:43 AM, Jens Axboe wrote:
> On 12/14/19 7:53 AM, Pavel Begunkov wrote:
>> There is no reliable way to submit and wait in a single syscall, as
>> io_submit_sqes() may under-consume sqes (in case of an early error).
>> Then it will wait for not-yet-submitted requests, deadlocking the user
>> in most cases.
>>
>> In such cases adjust min_complete, so it won't wait for more than
>> what have been submitted in the current call to io_uring_enter(). It
>> may be less than totally in-flight including previous submissions,
>> but this shouldn't do harm and up to a user.
> 
> Thanks, applied.

This causes a behavioral change where if you ask to submit 1 but
there's nothing in the SQ ring, then you would get 0 before. Now
you get -EAGAIN. This doesn't make a lot of sense, since there's no
point in retrying as that won't change anything.

Can we please just do something like the one I sent, instead of trying
to over-complicate it?

-- 
Jens Axboe

