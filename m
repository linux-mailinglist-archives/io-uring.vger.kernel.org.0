Return-Path: <io-uring+bounces-12194-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPULK+xDj2k5OgEAu9opvQ
	(envelope-from <io-uring+bounces-12194-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 16:31:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4323A13794B
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 16:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7B9F4300C016
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 15:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401E41F91F6;
	Fri, 13 Feb 2026 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDqe6AgX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA534FF41
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770996713; cv=none; b=mvjs48h/Guh1rst3Uyf/GUSr4zrfj9gCkkH96A5ZFGP2tzkcZkLKT6w1s+234qxWYkmjLTef4bdZJ4YBKBdBUAmNn3VJiymLxp3MwqjFXPcLtKoZ28wA8HmwP0//wztUfkOtgjC5AArR0sPBdLr9AGH+v9brJ1ieX4lsbu/uH3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770996713; c=relaxed/simple;
	bh=6qDPbqSxIRAJ1UOdj1tP3ojd69a//GQrXDkL7UfpyYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vAcQDmO4Fep0h4fnjA+eqprkK0K2sUXtCZg1ehwGy89fJf2rX8hkDEYqc9HIokz81b2MhPJXZokZpfSlyocz279D94P0eeWTonm6hwzXc85+uUJmQgHFvc7XUwS71TJPqHH9oPsYVUqwNq/vbEi8UFIDqLCeuTcLS+w2DykxSoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDqe6AgX; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-482f2599980so12037655e9.0
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 07:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770996710; x=1771601510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jAqnsNsfzUGZxCpjr9iGVWjF00qwBcxAYTHVAD7VEgU=;
        b=eDqe6AgXhYIvVhrgLoinc2LJyRK3KCOZ6yd3UuhUkwwQ1otcAypV7Uo1v2uL2s3v/x
         p8kQ9bFUYiwuJAfvTwqNFy9RsbkgWH6djJQmG8SeSHUONVyPEKZvF8LqE826OwwIniAC
         phO7sOZbdtIAjwDT+gR3hSl+2j/WwgqAzlZag70uxZ/a535gW2zD7yobr7jk3HeoLUdW
         IhYQKvBrtUDz4CrNZnQuz0Gx19TCygFEyNttiw2gjixwHvnaxB4tvFk/5uR3731DLhUe
         7qwrwc2IMhv7unHiwxtVP7INuvuNd8pJnmG97ql2Lslp2RQ246pqfSm0VTLSPEONV2G4
         eoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770996710; x=1771601510;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAqnsNsfzUGZxCpjr9iGVWjF00qwBcxAYTHVAD7VEgU=;
        b=kWHe7GFdfg9/x+6sPCyVbU4TWxRA5tqLan1iMOM1KsBvS4fwT/dtcfxYGldbRj5hSZ
         hk5w69OJkrSlC2J54yYlTv3coiy6vPkW43UYFSsFA554jvzU/eGJIleZM02/jtXPcr72
         cwLo0Wv/rQfMCS1MnjWghwrNzPMDlK5kKb+wTFD9focr+r0eKi17OTu+zNOpCmcCVOzV
         kvs2WZ2SrBOO3IQKWxwicWn4YS2mYUKufPk2+Aq89riP3qBEQ1lV0vnKdLrUoP0g59Cl
         REfvqDiXtUhTbzR2geovJFdAy50MOFm2hcQi2oYALvt/HwrATZiD2VOhok9f/uWHks+P
         sFkw==
X-Forwarded-Encrypted: i=1; AJvYcCUA3Xww6K+ulpY7Vb+G3whnn6gXZZ1EbGRN3f9c8OFF5y8zLgGEwAp3OksZf/pm2GsC67Dq5sV/5w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7vjhoVtRFrT3IswV8esnL85aJV1gQCzIWIIdoJQeE/7KA96lW
	TY/3f/BUVoR17iSGQhV5wgwU6LtIrZh+3e0LVj4WQMR4hM6eDe9vhbWe
X-Gm-Gg: AZuq6aKjCjHg/p7bOgCE1kkzc6jBtrJeoU8cpSXsjG+cFBP7dMsVlvBH1e8hrjS5Lry
	gf+ENQLfWVVVvTwxgOOGE0XSguL+7YhRy/iMDFQiVCTgr1naHqqJ4SuaYhTopEM7uByOOpHDSie
	rIt51k0DDjLDBAmjm+YdQJfVjSceR2sayYGTmPUGoZDO24AdUay0UA2zJx+lREG15u66snDJIOr
	ALRi2M3hHrAwTHIJE05Ms4j0vWACeAWmzo/mi2TMkqw1LKFm9TxMQlEOQGEIwbz5U4ldQjYeAKd
	kY6PVjY9I0zTlcL68whvJnfF71xqhYhGxRzK1iPJ5HKbUfPtWCn+xJzzsMc2IO2+DkNn4JY+Epz
	8v1hALqEkY5Kqm6npr7UbP9YCPg8ELyB7DejdhTQkp+A+0Gr6ZAiAHnAEp56y4f4R1G+dhknc1E
	IYRrs/1SQM+0Rmu5xdMkUVuGaEXQId+3yo+l3g89/4le87t9Riv9r8uPEv7TLRnVSmf9ayo3B6H
	3atQGm4MJlo2pXHELQSZHfVRqUdzcSVcFglAfZOyk/B92bk1Q4ZccTyyA==
X-Received: by 2002:a05:600c:1908:b0:479:1b0f:dfff with SMTP id 5b1f17b1804b1-48373a1bbb9mr40676725e9.10.1770996710097;
        Fri, 13 Feb 2026 07:31:50 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c974])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a3eb7asm33015405e9.1.2026.02.13.07.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 07:31:49 -0800 (PST)
Message-ID: <7c241b57-95d4-4d58-8cd3-369751f17df1@gmail.com>
Date: Fri, 13 Feb 2026 15:31:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Christoph Hellwig <hch@infradead.org>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, csander@purestorage.com,
 krisman@suse.de, bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org>
 <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
 <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
 <aY7ScyJOp4zqKJO7@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aY7ScyJOp4zqKJO7@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12194-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[infradead.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4323A13794B
X-Rspamd-Action: no action

On 2/13/26 07:27, Christoph Hellwig wrote:
> On Thu, Feb 12, 2026 at 09:29:31AM -0800, Joanne Koong wrote:
>>>> I'm arguing exactly against this.  For my use case I need a setup
>>>> where the kernel controls the allocation fully and guarantees user
>>>> processes can only read the memory but never write to it.  I'd love
>>
>> By "control the allocation fully" do you mean for your use case, the
>> allocation/setup isn't triggered by userspace but is initiated by the
>> kernel (eg user never explicitly registers any kbuf ring, the kernel
>> just uses the kbuf ring data structure internally and users can read
>> the buffer contents)? If userspace initiates the setup of the kbuf
>> ring, going through IORING_REGISTER_MEM_REGION would be semantically
>> the same, except the buffer allocation by the kernel now happens
>> before the ring is created and then later populated into the ring.
>> userspace would still need to make an mmap call to the region and the
>> kernel could enforce that as read-only. But if userspace doesn't
>> initiate the setup, then going through IORING_REGISTER_MEM_REGION gets
>> uglier.
> 
> The idea is that the application tells the kernel that it wants to use
> a fixed buffer pool for reads.  Right now the application does this
> using io_uring_register_buffers().  The problem with that is that
> io_uring_register_buffers ends up just doing a pin of the memory,
> but the application or, in case of shared memory, someone else could
> still modify the memory.  If the underlying file system or storage
> device needs verify checksums, or worse rebuild data from parity
> (or uncompress), it needs to ensure that the memory it is operating
> on can't be modified by someone else.
> 
> So I've been thinking of a version of io_uring_register_buffers where
> the buffers are not provided by the application, but instead by the
> kernel and mapped into the application address space read-only for
> a while, and I thought I could implement this on top of your series,
> but I have to admit I haven't really looked into the details all
> that much.

There is nothing about registered buffers in this series. And even
if you try to reuse buffer allocation out of it, it'll come with
a circular buffer you'll have no need for. And I'm pretty much
arguing about separating those for io_uring.

-- 
Pavel Begunkov


