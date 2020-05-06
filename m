Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE21C7121
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgEFM4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 08:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728173AbgEFM4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 08:56:22 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5D6C061A0F
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 05:56:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w7so1242180wre.13
        for <io-uring@vger.kernel.org>; Wed, 06 May 2020 05:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3s+v+xRv6rNz1DJIK08eM4riAGUqlWYpBJhi7rOUDRE=;
        b=mGfT0tru8cEKvYxCNeJ8EGvSULyVReqOYJDxkl6pvwmaOCF3/xhZPuCFagRMz2zda7
         SNWALUJG8GUYkM6kgYjMtSRc/G7W0CVhHDxjWfUmG2v/D3PfqkktVMpHjrujLOv2G/sk
         auw39Xcx3s/fPcqUyPYsAoCguscp8txVzzgA9ySb/UgFOT/Mcii00J0GoREAwrfwZrEA
         XVt8k+x0VUmRzey7oGM4Vz0SwYB1dp9vEyHK/k8gOUXiHzuENvW6Yc5YCrH2EduUzlZR
         ESyZJSXnlwVkK77ZOCIZP4XOnX5wM9NTxtkYJJWEJsi3vQzr4MCVKMwzTDzla66luGvo
         C0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3s+v+xRv6rNz1DJIK08eM4riAGUqlWYpBJhi7rOUDRE=;
        b=Q2IphbSsUe7rPVgvxkZndFomVDzu5od2UP3QY6PaLSnPTVwB3qOZ3bchJj/Yx16l5q
         FPA5KZrYWaS8+9bvc66wbZKk66mc+KF8gi5zAj6cXS4Dztf7GRps99firZtIMC86SSjp
         TIMNfoKuBTPLjxlTU4GpLoKTnl/atRZmmyp/1b9muJ7WMgbjXzMm7XSgJlRiUKfVDc+M
         9T2DMo+Bjvgjo9oR3OAY/vuZdlqTxTNexcxQLNi502qAO/FZb/wQDxl8o66rKYXZ0R5v
         sZ42WETNhdpBHSE83QyuaTlMQad15TUnuxToFWfH8ohsyQWPPCFejqxCw+S604pv/54u
         MpUA==
X-Gm-Message-State: AGi0PuauOW8swO9JjawrfLY08ZRaNr4YEs0Ipck/q9LMbv9YBsn1QPot
        8Rd40uZ5B8saJKmV0YF9R4zHFIdZj+A=
X-Google-Smtp-Source: APiQypIG9n3BCGkRnyd7jvrhLFfZB+WkUAh8PJGr77DvYake2rBO4oouJEmymLlHGoIjf4gqC3BO4g==
X-Received: by 2002:adf:810a:: with SMTP id 10mr9880145wrm.101.1588769780898;
        Wed, 06 May 2020 05:56:20 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id g6sm2720043wrw.34.2020.05.06.05.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 05:56:20 -0700 (PDT)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
Message-ID: <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
Date:   Wed, 6 May 2020 15:55:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/05/2020 23:19, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Got it working, but apparently the arch samba doesn't come with io_uring...
>> One question, though, from looking at the source:
> 
> Thanks for taking a look!
> 
>> static ssize_t vfs_io_uring_pread_recv(struct tevent_req *req,
>> 				  struct vfs_aio_state *vfs_aio_state)
>> {
>> [...]
>> 	if (state->ur.cqe.res < 0) {
>> 		vfs_aio_state->error = -state->ur.cqe.res;
>> 		ret = -1;
>> 	} else {
>> 		vfs_aio_state->error = 0;
>> 		ret = state->ur.cqe.res;
>> 	}
>>
>> 	tevent_req_received(req);
>> [...]
>>
>> I'm assuming this is dealing with short reads?
>>
>> I'll try and see if I can get an arch binary build that has the
>> vfs_io_uring module and reproduce.
> 
> I guess I don't expect short reads for files unless the client asked
> for a read beyond EOF. Does IORING_OP_READV may return short reads
> similar to preadv2 with RWF_NOWAIT? And if so, did this got changed
> since 5.3?

AFAIK, it can. io_uring first tries to submit a request with IOCB_NOWAIT,
in short for performance reasons. And it have been doing so from the beginning
or so. The same is true for writes.

> 
> By default Samba uses pread()/pwrite() from within a helper thread
> and I modeled the io_uring module with the same expecations that
> we wouldn't get a short read if only part of the requested buffer (can
> be up to 8MB) is returned because only some of it is already in the
> buffer cache.
> 
> I'll try the ubuntu 5.4 kernel tomorrow.
> 
> metze
> 

-- 
Pavel Begunkov
