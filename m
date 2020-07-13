Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB95D21D152
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 10:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGMIEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 04:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGMIEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 04:04:50 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF38C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 01:04:50 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so15372601ejg.12
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 01:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P2dArLcSU6hb6jHjIbjz9uecxKrl9ZecOs3L7bMHY0U=;
        b=saO/XQY12iwy+LthchsA2oEqdsMrbB753hrT41iE1gIckFrD4GsoWmFjEyg7BTekny
         EEUtIX5Mye0w6qhqwpMMIX5qRgaL24kbbeJhkU6JxIzcK0z7rfsdrio6Yi/2xIBnCyWE
         UKepU0+7vwmwrszmvNPbnyfjTBU1Cyh7xw9r++o+FJrPWkCqrsbWiNQi78lTMxkchNbJ
         fhIY3sEVYURH6dXI3FoO+q16C98AMpg73DBPDUsHvQzq/BQdoVKQDve27jg72sj15WRI
         n3YpQxo5UIhI2vCTz1V4txpWEYM/CsuxYeI026puGnxQaDVESgIrOchxvR6LeaIdNiqp
         oAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P2dArLcSU6hb6jHjIbjz9uecxKrl9ZecOs3L7bMHY0U=;
        b=pzGk3JU4SrDXwCWuvhgO8UAPbg9WHeLkYkW6x+zj3tagSnbgEQ3zzM/ne7fcFQsXU1
         cG0B8t5osZ4BwbuDIaYhz7X0SwmYJHZhifznqy/jO/25ckoW0s2ZPIM8Flddit7Q+Bll
         XAGqGwvpeLKrWyHGMzNeF5Oi150Pap3geL7H4bUgIaJdLHQRZT5UUo4vLaK3S5fTOX3I
         es/F5ATt3mtSnEgw2iH5iA4WpgTJExb15hA0Lxg5ZBSbXtWfFrnALwhmPJkHb5WapH8S
         W1xUTNbA6SnOTHYZBdFhqR/Rm4GOxsNRCM1Q/uAeqf7mtJq3nNa+aDi1o6ByqgJCOrz4
         dvfg==
X-Gm-Message-State: AOAM532pjzNIXT60MIO99z0Zjqv8dz2LU57Mxa+nz5Q4x06qyD03UV2r
        CWpUYrW218ATHwz3agsJuiyKPpPo
X-Google-Smtp-Source: ABdhPJyfmlpz7PHV7TcQnTyQPe5jb36Nyr4PIFkAWG8vsuLLCz6dc6CRb3EJts1jeagiFydvp1sN0g==
X-Received: by 2002:a17:906:6d56:: with SMTP id a22mr74969361ejt.440.1594627488792;
        Mon, 13 Jul 2020 01:04:48 -0700 (PDT)
Received: from [192.168.43.17] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id dn15sm9480917ejc.26.2020.07.13.01.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 01:04:48 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <6cd829a0f19a26aa1c40b06dde74af949e8c68a5.1594574510.git.asml.silence@gmail.com>
 <5356a79b-1a65-a8bb-2f21-a416566bad1a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.9] io_uring: replace rw->task_work with rq->task_work
Message-ID: <494e8054-38dc-4987-e82b-00edeb70400c@gmail.com>
Date:   Mon, 13 Jul 2020 11:03:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5356a79b-1a65-a8bb-2f21-a416566bad1a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/07/2020 23:29, Jens Axboe wrote:
> On 7/12/20 11:42 AM, Pavel Begunkov wrote:
>> io_kiocb::task_work was de-unionised, and is not planned to be shared
>> back, because it's too useful and commonly used. Hence, instead of
>> keeping a separate task_work in struct io_async_rw just reuse
>> req->task_work.
> 
> This is a good idea, req->task_work is a first class citizen these days.
> Unfortunately it doesn't do much good for io_async_ctx, since it's so
> huge with the msghdr related bits. It'd be nice to do something about
> that too, though not a huge priority as allocating async context is

We can allocate not an entire struct/union io_async_ctx but its particular
member. Should be a bit better for writes.

And if we can save another 16B in io_async_rw, it'd be 3 cachelines for
io_async_rw. E.g. there are two 4B holes in struct wait_page_queue, one is
from "int bit_nr", the second is inside "wait_queue_entry_t wait".


# pahole -C io_async_ctx ./fs/io_uring.o
struct io_async_ctx {
        union {
                struct io_async_rw rw;                   /*     0   208 */
                struct io_async_msghdr msg;              /*     0   368 */
                struct io_async_connect connect;         /*     0   128 */
                struct io_timeout_data timeout __attribute__((__aligned__(8)));
							/*     0    96 */
        } __attribute__((__aligned__(8)));               /*     0   368 */

        /* size: 368, cachelines: 6, members: 1 */
        /* forced alignments: 1 */
        /* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));


> somewhat of a slow path. Though with the proliferation of task_work,
> it's no longer nearly as expensive as it used to be with the async
> thread offload. Could be argued to be a full-on fast path these days.
> 
> Applied, thanks.
> 

-- 
Pavel Begunkov
