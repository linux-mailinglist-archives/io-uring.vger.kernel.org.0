Return-Path: <io-uring+bounces-1102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7AE87E9FB
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14A841F22525
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 13:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7558645BEB;
	Mon, 18 Mar 2024 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PlQ+c4bl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15674438F;
	Mon, 18 Mar 2024 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710768058; cv=none; b=RRMjfuCpzA874WAZHompfdX4dNKqOwstOa+OnqJd5ELnjc2hbg35I7ZUpHdhK0gtwQwPJkFPCpeMKHwdgVGnBjxD0cthuM/uONn3kn9fHT4Em2MynzAGzP5KsBsWxpDY+QFbuY4JbwvTGEzeT0VzaOyerPr0c6zsS4DwoQH5OfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710768058; c=relaxed/simple;
	bh=Ro9DhNywcl6K5qDRLecjZIB/mP5nv+WPca/RqnMk09M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZIOWwun8+lN98l85XYRMmVYQYYAR7Xj0TYWftt5WYkF7WR1GtwHoLWH+WsmxgcGhXwm45w39uIDQKHhH7yTboZ7M7Grz07BvR+MVm5Dqet2wfu5S1mEow8YgppGcDVahnNo/hdyYhBmRnrvJTwDHA/XbF4M3VXb8MfahNDPv7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PlQ+c4bl; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d41d1bedc9so73982051fa.3;
        Mon, 18 Mar 2024 06:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710768055; x=1711372855; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B6f1uddVmun0jJOTXaZCQpPLYe/6XOnd9oX08SFGjC0=;
        b=PlQ+c4bl91Dpmes14fBswcC6BcIbol49w+sQwMRe/TAeUvvaM3ac2D3bcjkLQiab3e
         kxvAeD1ESF4SceQgKmgzJ2UA0gDA+vS5cLHgahaKEv6qs03SWOck70/XdJDI5IWog36G
         Cc+kEbTy24WU4yCgCy+Y4HAA703c6iV7BjFvAktvlPwl0C1VqO2zid2eAmG9iHyWh/iv
         SsvqDm1zzIKjeBUAg0lAfUvfOYrrUEsLEVsmRit3cs4k1W6IIhUbQ4Bye+krtc3Z550S
         KEnewm6A/DwcFKXC2Vr8QdYGhMrYWiiV9BZu4obD1LP6Duww0X5bGdkL4fyHMV45JBNs
         d6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710768055; x=1711372855;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6f1uddVmun0jJOTXaZCQpPLYe/6XOnd9oX08SFGjC0=;
        b=k2jtj/y/Nc2CXNuqtZIKCbwLJ7H5zs20+up0seADMaJvYxQ8rbYg3MKRxgUUTIcfUV
         nRupgC/BSSsU5lYl3IbCYS1pSr5g3e9ETkcQLWJ4OFdUE4XCRPQJbPS+SH+aDMypfDgs
         xXzYP3sD0si/gFik5en7IqniCUyJN0sil25IYyFki5gLBa5mTf1HeZVbodjLo1p+FNaj
         J0n31HArjK7r86gfTSN+H5ghZXrj+6MsMJnqF3qFwhCgCn5YIlAedi6Z9UZ8JDWXJJnl
         4y1lW5kvmqAQK7siIrtnQAhMHsEonIrR0GRpZnzTzCdxso5uuFd/nx8tO2P6JRtT7SAI
         HoIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+b8K65aybDDKyYXTuzO2rocOP3kcjpoyZgHHfUjkndoHF6J7zufyGTXC8F+0UM+9GsCzAyoNkWbVxz0+h9MUI/ElQHi3XdJdeqq+LErZg2ZiaduZlcN2cAlQrCN4jso248XCWhXY=
X-Gm-Message-State: AOJu0YxDp+zm9pBLMxoc/K1SzjM4becevr4L6qgx4qcQS/V8SVg36l4B
	LfuC9/G4otewzdSgH8auYTA1MwjV2l6sc499NO8S1papeFhZ408Z
X-Google-Smtp-Source: AGHT+IGo7h2AxBg2UxkUko/nh1IfJYKCRKIBQwNwYP8I35nwUeXbiEw4QWW6hWgGVAaLpuqdbDqs6Q==
X-Received: by 2002:a2e:9bcd:0:b0:2d4:5c03:5ccb with SMTP id w13-20020a2e9bcd000000b002d45c035ccbmr5121261ljj.10.1710768054395;
        Mon, 18 Mar 2024 06:20:54 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:429a])
        by smtp.gmail.com with ESMTPSA id wk18-20020a170907055200b00a46c7ecb464sm709545ejb.27.2024.03.18.06.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 06:20:54 -0700 (PDT)
Message-ID: <0a556650-9627-48ee-9707-05d7cab33f0f@gmail.com>
Date: Mon, 18 Mar 2024 13:19:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
Content-Language: en-US
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: netdev@vger.kernel.org, kernel@pengutronix.de,
 linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
 <7b82679f-9b69-4568-a61d-03eb1e4afc18@gmail.com>
 <ZfgvNjWP8OYMIa3Y@pengutronix.de>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZfgvNjWP8OYMIa3Y@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 12:10, Sascha Hauer wrote:
> On Fri, Mar 15, 2024 at 05:02:05PM +0000, Pavel Begunkov wrote:
>> On 3/15/24 10:01, Sascha Hauer wrote:
>>> It can happen that a socket sends the remaining data at close() time.
>>> With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
>>> out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
>>> current task. This flag has been set in io_req_normal_work_add() by
>>> calling task_work_add().
>>
>> The entire idea of task_work is to interrupt syscalls and let io_uring
>> do its job, otherwise it wouldn't free resources it might be holding,
>> and even potentially forever block the syscall.
>>
>> I'm not that sure about connect / close (are they not restartable?),
>> but it doesn't seem to be a good idea for sk_stream_wait_memory(),
>> which is the normal TCP blocking send path. I'm thinking of some kinds
>> of cases with a local TCP socket pair, the tx queue is full as well
>> and the rx queue of the other end, and io_uring has to run to receive
>> the data.

There is another case, let's say the IO is done via io-wq
(io_uring's worker thread pool) and hits the waiting. Now the
request can't get cancelled, which is done by interrupting the
task with TIF_NOTIFY_SIGNAL. User requested request cancellations
is one thing, but we'd need to check if io_uring can ever be closed
in this case.


>> If interruptions are not welcome you can use different io_uring flags,
>> see IORING_SETUP_COOP_TASKRUN and/or IORING_SETUP_DEFER_TASKRUN.
> 
> I tried with different combinations of these flags. For example
> IORING_SETUP_TASKRUN_FLAG | IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN
> makes the issue less likely, but nevertheless it still happens.
> 
> However, reading the documentation of these flags, they shall provide
> hints to the kernel for optimizations, but it should work without these
> flags, right?

That's true, and I guess there are other cases as well, like
io-wq and perhaps even a stray fput.


>> Maybe I'm missing something, why not restart your syscall?
> 
> The problem comes with TLS. Normally with synchronous encryption all
> data on a socket is written during write(). When asynchronous
> encryption comes into play, then not all data is written during write(),
> but instead the remaining data is written at close() time.

Was it considered to do the final cleanup in workqueue
and only then finalising the release?


> Here is my call stack when things go awry:
> 
> [  325.560946] tls_push_sg: tcp_sendmsg_locked returned -512
> [  325.566371] CPU: 1 PID: 305 Comm: webserver_libur Not tainted 6.8.0-rc6-00022-g932acd9c444b-dirty #248
> [  325.575684] Hardware name: NXP i.MX8MPlus EVK board (DT)
> [  325.580997] Call trace:
> [  325.583444]  dump_backtrace+0x90/0xe8
> [  325.587122]  show_stack+0x18/0x24
> [  325.590444]  dump_stack_lvl+0x48/0x60
> [  325.594114]  dump_stack+0x18/0x24
> [  325.597432]  tls_push_sg+0xfc/0x22c
> [  325.600930]  tls_tx_records+0x114/0x1cc
> [  325.604772]  tls_sw_release_resources_tx+0x3c/0x140
> [  325.609658]  tls_sk_proto_close+0x2b0/0x3ac
> [  325.613846]  inet_release+0x4c/0x9c
> [  325.617341]  __sock_release+0x40/0xb4
> [  325.621007]  sock_close+0x18/0x28
> [  325.624328]  __fput+0x70/0x2bc
> [  325.627386]  ____fput+0x10/0x1c
> [  325.630531]  task_work_run+0x74/0xcc
> [  325.634113]  do_notify_resume+0x22c/0x1310
> [  325.638220]  el0_svc+0xa4/0xb4
> [  325.641279]  el0t_64_sync_handler+0x120/0x12c
> [  325.645643]  el0t_64_sync+0x190/0x194
> 
> As said, TLS is sending remaining data at close() time in tls_push_sg().
> Here sk_stream_wait_memory() gets interrupted and returns -ERESTARTSYS.
> There's no way to restart this operation, the socket is about to be
> closed and won't accept data anymore.

-- 
Pavel Begunkov

