Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF5E351BE1
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhDASLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhDASGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:06:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A552EC00F7EC
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 08:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=fhByhXQt3cgT8dORAyRiRmoTAIsa21eOzx/s/2SElXU=; b=c3K7OiWoAwNPSgTiIaJ7LaaVK+
        7+rpVaPR05N4Bxf9yX5RaUoBmqFQ60XgSYkChDYhGJFs2NDXvcZWXu1FVFZ8/aV8J784vsfJ9nEWp
        jN0jZ1WX2JpnvoUJZbvof9m5Cu7xkgyOemA1U1drTHf7lxve0f+3dAGghm9h4uu9W0XV6wigv3Vt0
        ubM1d09Tt9INx/rci53IqIGABFSj8TDogFxS2HolwDWeH3RsAOX1oM22Y1Kaz+GhGUJ3hvljf60rb
        WWod9A7uyx3LgUFLinVgHerwUddjSo7fOFSSmm2o5hR99m1DdyvXubQGfz+BGVaNPeiLcRsnusHM8
        upuPt4ysdISt3oUzfHgTed+XO6szh+9K+HILjof67U1XD+X1qQ4PmtTq+u5dxJHvKWyrRusf4I0pV
        JaSqVMA08yIOk6wZdh6i8YtGthhXmCFvci3wWVwFqezRE4vTuYAJ/xjFxupU4VmHvgnSsgETF8cwT
        ikrl7BAj6fTcSqAaM5ivg68s;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRywi-0007a1-3K; Thu, 01 Apr 2021 15:09:20 +0000
Subject: Re: buffer overflow in io_sq_thread()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <YGTamC6s+HyF+4BA@localhost.localdomain>
 <55d32b30-ea39-c8b2-2912-8e7081e0f624@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <6a5273f0-e54b-ac4b-21f6-3129aca72ec6@samba.org>
Date:   Thu, 1 Apr 2021 17:09:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <55d32b30-ea39-c8b2-2912-8e7081e0f624@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 01.04.21 um 10:51 schrieb Pavel Begunkov:
> On 31/03/2021 21:24, Alexey Dobriyan wrote:
>> The code below will overflow because TASK_COMM_LEN is 16 but PID can be
>> as large as 1 billion which is 10 digit number.
>>
>> Currently not even Fedora ships pid_max that large but still...
> 
> And is safer limited in any case. Thanks
> 
>>
>> 	Alexey
>>
>> static int io_sq_thread(void *data)
>> {
>>         struct io_sq_data *sqd = data;
>>         struct io_ring_ctx *ctx;
>>         unsigned long timeout = 0;
>>         char buf[TASK_COMM_LEN];
>>         DEFINE_WAIT(wait);
>>
>>         sprintf(buf, "iou-sqp-%d", sqd->task_pid);

I have patches for this see
https://lore.kernel.org/io-uring/1213a929-30f2-592d-86a2-ddcf84139940@kernel.dk/T/#m9a9707c76e0ca73b54676b5d0fe198587b36c1b4

As there's no urgent problem in 5.12 I'll repost them for 5.13...

metze

