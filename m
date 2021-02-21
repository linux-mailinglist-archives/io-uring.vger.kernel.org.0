Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE92E320813
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 03:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBUCEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 21:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhBUCEs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 21:04:48 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07A6C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 18:04:03 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p21so7873960pgl.12
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 18:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=52rtrw7lG4YkvbFmsyjeEgpgiFrc4nWOZ+gI75Xv2Bg=;
        b=vsNtNLqCGxiH54Rr/12JC/l7kTHQn8+eMFFHCnzYgS7iX2QoV40RwDWBczpTrzznVc
         AQzUld5wk4ZcMCzZWrpSQrUehg3AUvSWNj1MPx0QnLDk//LVried0fYa+Y7L/Zj43G4Y
         TpkhKXV3bNONZ0LGPbQPFFr25HrnQ+vmbCBEEgwBYeqZvBXLstYXp0RHYSneieCfOL1t
         TdSZP7ihkbnaMDnKRIhgcUAwZSnO5cC6kTH6NEL1sDUrDAaVkVV35ZUgJNHFhUPIXq/g
         xyFOnV0V40xRe7Pbn7SR+IXpf9C5g7nFF6Wv1NQFQOz2JBHaL2Be2Ae8kVhI9HmFMqfq
         9bWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=52rtrw7lG4YkvbFmsyjeEgpgiFrc4nWOZ+gI75Xv2Bg=;
        b=FWslW8n2DrEXNesIna1ICRSV0asuEAnRQV3/CvFcWn0eD0oQqKRfmjLNQJsBvT+3Av
         qd6S7zKDLGg/XunBICX9/eRB8TZwv/jWOkyz1bzm9CFWIczUzSDKhbHjkGMutfyMuBSp
         pLKjk/PEfLjL/nOTkGe0RTwHT7IrYyX5g9gM6h102eOUyji+TZmKCgdvfdiQTu467I3x
         QMXzdbAT5N9RYSG447+CEZEDAMaJUkCtlQXN8PGjBKsCwEEXWC+rbq/YkjYmfSrWUnml
         oKYV3814aA6EVwJwUXfRgDXUR1aig6xSGjEwY2gcg1EmZG0t973v1+4aI7hw/wJhOZX5
         UQxA==
X-Gm-Message-State: AOAM533uXPBDEEFCcCpwXEtAXY5oL//Ez9edZ1d6jEUaMFvFQ9QsKj0L
        LuLMximgISAoV841eIe9+jU6b0MnEBpcdA==
X-Google-Smtp-Source: ABdhPJy1ynRyBtrWQPK9pKVQtlHuUbfplH+u85v3HBsRTaMsXYRNFbBMNwQWx1dJyYnr6FBQO4CZlg==
X-Received: by 2002:a62:ae12:0:b029:1ed:6300:ac7d with SMTP id q18-20020a62ae120000b02901ed6300ac7dmr5528925pff.2.1613873042824;
        Sat, 20 Feb 2021 18:04:02 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s138sm183496pfc.135.2021.02.20.18.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 18:04:01 -0800 (PST)
Subject: Re: [PATCH 2/3] io_uring: fail io-wq submission from a task_work
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613687339.git.asml.silence@gmail.com>
 <ae6848eec1847ff3811f13363f15308f033e7d41.1613687339.git.asml.silence@gmail.com>
 <66ba85b1-090e-0765-2dec-776c4f7e0634@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79fb361a-0c28-6cbb-d443-0e908c88fd4a@kernel.dk>
Date:   Sat, 20 Feb 2021 19:03:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <66ba85b1-090e-0765-2dec-776c4f7e0634@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/21 6:01 PM, Pavel Begunkov wrote:
> On 18/02/2021 22:32, Pavel Begunkov wrote:
>> In case of failure io_wq_submit_work() needs to post an CQE and so
>> potentially take uring_lock. The safest way to deal with it is to do
>> that from under task_work where we can safely take the lock.
>>
>> Also, as io_iopoll_check() holds the lock tight and releases it
>> reluctantly, it will play nicer in the furuter with notifying an
>> iopolling task about new such pending failed requests.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>> @@ -2371,11 +2371,22 @@ static void io_req_task_queue(struct io_kiocb *req)
>>  	req->task_work.func = io_req_task_submit;
>>  	ret = io_req_task_work_add(req);
>>  	if (unlikely(ret)) {
>> +		ret = -ECANCELED;
> 
> That's a stupid mistake. Jens, any chance you can fold in a diff below?

Yup done.

-- 
Jens Axboe

