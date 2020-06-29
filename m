Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF62020D734
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 22:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgF2T1v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732759AbgF2T1t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:27:49 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC33C0307AB
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 08:52:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e9so8475249pgo.9
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 08:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iAq8XDVnb1ef9l+Lalm1c0y9ycxgPbqvuqgG2Tu4cJw=;
        b=sUlPaJAcM6ivRfM1qTpRztCgvqK4xgq9ikyW0bLQ+8eiu1Mnmwa24WMpvLU4vZ5UH3
         7owDhHZ0/3I9+ghDeBKE96BgYQANASW7odQoqflejadv6q4KlvoPZgy8Hfk+saMZB7yn
         CWldFC253IhrERB5pPn92PuTsq+qqwhjwqE7Tlt7DyO4Wf69DO3G3JqI77a+s+6qzr/D
         Lvw8Uxf5h+jPQzBxBrytZ71e1hajpHzv6Jhwz0ZsXHo3TBiGV5QMkfKCn0ljVpJuwxqM
         ry6W4bpBU0HuNB47ynaBlJUmJNLF8EqFHKSFQbxyz5RS7aY74tI5EdrN5n14GohHeJs9
         DQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iAq8XDVnb1ef9l+Lalm1c0y9ycxgPbqvuqgG2Tu4cJw=;
        b=czErEyddXbixZAejPKmFNohtxKBzbRL9/CrnIq8d1aRQIxuFyiXl7C53ZfUULAWk+0
         j+lMjBDpmn3vzkwcys5Be09G89Cy7PPRI69sYM5iJQXhAqiJnj1Nq0Lzx9EvR62/6eA6
         ShLtgQiMnrG4xF0NQyiEkDdrlZes7l4B7aWqa7IOQSGZjqgTNyqVS6+Hjrfx47Y3VvAm
         YrMn2TRCi6RCf776VLYCS1IdCWFuL6LBd4vvcnai4MBkAZhV+zk2MHucqkosFjafmUjt
         r9IpXi/Bk1GIBXG7Vq/EymUUDcIZ8qTXY1z9jKEcepWtnV95WzL30oaWzNEKseadmCQ1
         ePnA==
X-Gm-Message-State: AOAM533lTORfjIubsDEftp2lfT4LJs5ryTr86v2Emc2NF7iKkvt6tx/S
        wm9wyucmDNDb6yq0daCqkdMqwQldPbB0Eg==
X-Google-Smtp-Source: ABdhPJzQKvWJH3Esfo4PXIZoHtCGcSx07AiYxan4Dp9zD7yyxy6WA9V2BwBy/9sZ+tHteEd0JFlW3g==
X-Received: by 2002:a63:db57:: with SMTP id x23mr1002956pgi.178.1593445958819;
        Mon, 29 Jun 2020 08:52:38 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id q1sm155733pfk.132.2020.06.29.08.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 08:52:38 -0700 (PDT)
Subject: Re: [PATCH 0/5] "task_work for links" fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593253742.git.asml.silence@gmail.com>
 <05084aea-c517-4bcf-1e87-5a26033ba8eb@kernel.dk>
 <328bbfe9-514e-1a50-9268-b52c95f02876@gmail.com>
 <14de7964-8d8d-9c10-7998-c06617ef5800@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <23051425-13b5-fd2c-94f7-6f28677cfc6c@kernel.dk>
Date:   Mon, 29 Jun 2020 09:52:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <14de7964-8d8d-9c10-7998-c06617ef5800@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/20 4:21 AM, Pavel Begunkov wrote:
> On 28/06/2020 17:46, Pavel Begunkov wrote:
>> On 28/06/2020 16:49, Jens Axboe wrote:
>>> On 6/27/20 5:04 AM, Pavel Begunkov wrote:
>>>> All but [3/5] are different segfault fixes for
>>>> c40f63790ec9 ("io_uring: use task_work for links if possible")
>>>
>>> Looks reasonable, too bad about the task_work moving out of the
>>> union, but I agree there's no other nice way to avoid this. BTW,
>>> fwiw, I've moved that to the head of the series.
>>
>> I think I'll move it back, but that would need more work to be
>> done. I've described the idea in the other thread.
> 
> BTW, do you know any way to do grab_files() from task_work context?
> The problem is that nobody sets ctx->ring_{fd,file} there. Using stale
> values won't do, as ring_fd can be of another process at that point.

We probably have to have them grabbed up-front. Which should be easy
enough to do now, since task_work and work are no longer in a union.

-- 
Jens Axboe

