Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACF816AE81
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXSQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:16:34 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42721 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXSQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:16:33 -0500
Received: by mail-io1-f68.google.com with SMTP id z1so181471iom.9
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ovhpVTFP4cZPubVNB4UyKe30e0iEggWVzfTJMRFFLcI=;
        b=WB9IcpjB0tOfIFhtt8xUhKc5W4GMwHxcqTGy/ujRjdPJzIl1BK4bpwKchogIn6uLuj
         PrBszL9Cy5qdltx8CDWUY78KybhsGFCe9RNPAtQq3iNOzvbwvv1kju2DGH5Nvb1wXDyG
         ZDRSwqvLm6tEjLI8gk/Q2laEiXYtC3Mr/JrJFwYqQsD9pvSirgA0zOFIyaJKll+o+2EU
         Kb57NijPlAN0nWDl7XqvCgsMx0LrT5OR1BnteUochCK39RU0++yKtUqnrFGmQt18gdvp
         SVfAGtr6sqymy4ECxgPpC+LiQIgAGVjERFugsIlbes/bS5+7Yfjrbdnk15MlZeePXdB+
         Fu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ovhpVTFP4cZPubVNB4UyKe30e0iEggWVzfTJMRFFLcI=;
        b=O7G4tsMavzI7JyTxbje+D02mRo9Advq8y/+K/feCBPDcODWuukpYuV3tvV997v8eTL
         HIRrdC0YAKfSjU3C5goCInDKC1mO6MmJyiZDI+ieScCVxxM4FbKLnKyZXqzQPLvv6+j0
         c7Ex2tRROfP8M5N0P+R3peAYJZ61lbGHDe6EfXbP9pNPTGlU6X/QymW1ilwnUC9IF7bc
         nZFuiVFrI3oN2p0X3KsJcaWlW7CIkrTyQOqDgnxQLfh1eSpGKs50O+faJPchhFAvd6k/
         Hht0pdlO55ZF2Pe29y56N3YTOjkK2L4qzHMDvEp8Aa1h6WOwya0KRzwiYakNUZ5J4fQq
         6zeg==
X-Gm-Message-State: APjAAAX77M9mwNHFd67C5+Zs9mC5heNYj/Vo9bbZe03B5qz+LqnD1hXm
        Ue5Q4v/Kc0AEGCshTOj9U7W/mocSWyw=
X-Google-Smtp-Source: APXvYqy9QK7/SHsj4CU60KxDWSd1hKwiHzUo1/RNC6uhzHS1NnGj1W3LryPSHQy0VIUs5H4cQIp0GQ==
X-Received: by 2002:a02:cd0d:: with SMTP id g13mr55026962jaq.110.1582568192615;
        Mon, 24 Feb 2020 10:16:32 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i13sm3146552ioi.67.2020.02.24.10.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:16:32 -0800 (PST)
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
 <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
 <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <abe952ad-54d8-1d18-7fe6-6a7f1666b7e0@kernel.dk>
Date:   Mon, 24 Feb 2020 11:16:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:40 AM, Pavel Begunkov wrote:
> On 24/02/2020 18:27, Jens Axboe wrote:
>> On 2/24/20 2:15 AM, Pavel Begunkov wrote:
>>> It seems no opcode may return -EAGAIN for non-blocking case and expect
>>> to be reissued. Remove retry code from io_wq_submit_work().
>>
>> There's actually a comment right there on how that's possible :-)
> 
> Yeah, I saw it and understand the motive, and how it may happen, but can't
> find a line, which can actually return -EAGAIN. Could you please point to an
> example?

Just give it a whirl, should be easy to reproduce if you just do:

# echo 2 > /sys/block/nvme0n1/queue/nr_requests
# fio/t/io_uring /dev/nvme0n1

or something like that. It's propagated from the kiocb endio handler,
through, req->result at the bottom of io_issue_sqe()

	if (ctx->flags & IORING_SETUP_IOPOLL) {
		const bool in_async = io_wq_current_is_worker();

		if (req->result == -EAGAIN)                                     
			return -EAGAIN;
	[...]


-- 
Jens Axboe

