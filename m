Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183646BDE89
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 03:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCQCRK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 22:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCQCRI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 22:17:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904FDB1B16
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 19:17:06 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l14so2251205pfc.11
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 19:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679019426;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v539qyeIQ5RinGqrnC9+WCBagAAEoFv6Jz/V5aiB6u4=;
        b=nf/BVxcCmg2On0gzuIQPUG9pYfJJ+Y3w1x1P7JCuxTxt+2vXYs6Lx7P+hb/yARp7ZB
         6ocrQehalIT3ey2tnyvjY3Ih4f1HsTQ5ayAatSnp0MhwVCyxk1Q8h+rwwgQLmcSmuClb
         M/8giTcbZSXxnNG6PzbJGwFQg7kvCR/8/wu0uTWr/mn+69votV/7jILfsgssQYdQxnmK
         LkalQaK1Be+qz9fhTmE308cXmVi96znzfFvcMJEv4pgpmlvQvB+98zk7Tza7YTOid7VQ
         9A7qVTIzymfK50IcqjQ2QQl9s/lNvoudjLLGjk8/WnjCH/9H13GplPZu2OD4Ozt2sMUV
         o3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679019426;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v539qyeIQ5RinGqrnC9+WCBagAAEoFv6Jz/V5aiB6u4=;
        b=oZEoaczuVWAdnOS7ZE9MENUcWuF5/3RXGnyabgOwVOFDxfE236m75vqw0RcJk+euwI
         bfU1NXFCYXnuDlHyKsENZFjqXuSm7YPX0pyH6D/gi32mHYRBLTXvJUO5Be81nbUirHdC
         JKHbkC/seee6181fewrrSO2mS34UuijOXddaVtaLGlfS9r7PA0qqVhdBrhQoQ3rW1wI4
         0I3mSP+8MEM+PylQ4fkIHIsXE4POXwYcGt/rBA2ljqhpeA4+uVb1+6VYeAkEjOeWlt0o
         WxJdor1nWWpOdwv7tiL2KzVWExYpxRFrjgMmdb2zmAbtZ3/9HaZyC6dxLCqMYYlxLI/g
         98lA==
X-Gm-Message-State: AO0yUKXIWAedPi8j4TJ9gsM0SjXtX5rraqxhCYD6qo/FJta0BExQ5lDV
        EgGjdNuMjym8rVLussAiejEMzg==
X-Google-Smtp-Source: AK7set9q3jyWMAujNfuIxT+MdtCY65fet4E1RCsO9myB1QmSAfSXRTAEY9Uh/aYvp4uHLS/eb7CRow==
X-Received: by 2002:a05:6a00:234e:b0:5e2:3086:f977 with SMTP id j14-20020a056a00234e00b005e23086f977mr5278180pfj.2.1679019425942;
        Thu, 16 Mar 2023 19:17:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d16-20020aa78150000000b005825b8e0540sm321955pfn.204.2023.03.16.19.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 19:17:05 -0700 (PDT)
Message-ID: <827b725a-c142-03b9-bbb3-f59ed41b3fba@kernel.dk>
Date:   Thu, 16 Mar 2023 20:17:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
 <babf3f8e-7945-a455-5835-0343a0012161@bell.net>
 <29ef8d4d-6867-5987-1d2e-dd786d6c9cb7@kernel.dk>
 <42af7eb1-b44d-4836-bf72-a2b377c5cede@kernel.dk>
In-Reply-To: <42af7eb1-b44d-4836-bf72-a2b377c5cede@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 8:09?PM, Jens Axboe wrote:
> On 3/16/23 1:46?PM, Jens Axboe wrote:
>> On 3/16/23 1:08?PM, John David Anglin wrote:
>>> On 2023-03-15 5:18 p.m., Jens Axboe wrote:
>>>> On 3/15/23 2:38?PM, Jens Axboe wrote:
>>>>> On 3/15/23 2:07?PM, Helge Deller wrote:
>>>>>> On 3/15/23 21:03, Helge Deller wrote:
>>>>>>> Hi Jens,
>>>>>>>
>>>>>>> Thanks for doing those fixes!
>>>>>>>
>>>>>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>>>>>> One issue that became apparent when running io_uring code on parisc is
>>>>>>>> that for data shared between the application and the kernel, we must
>>>>>>>> ensure that it's placed correctly to avoid aliasing issues that render
>>>>>>>> it useless.
>>>>>>>>
>>>>>>>> The first patch in this series is from Helge, and ensures that the
>>>>>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>>>>>>> there.
>>>>>>>>
>>>>>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>>>>>> ring mapped provided buffers that have the kernel allocate the memory
>>>>>>>> for them and the application mmap() it. This brings these mapped
>>>>>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>>>>>
>>>>>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>>>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>>>>>> there are others) are impact to any degree as well...
>>>>>>> It would be interesting to find out. I'd assume that other arches,
>>>>>>> e.g. sparc, might have similiar issues.
>>>>>>> Have you tested your patches on other arches as well?
>>>>>> By the way, I've now tested this series on current git head on an
>>>>>> older parisc box (with PA8700 / PCX-W2 CPU).
>>>>>>
>>>>>> Results of liburing testsuite:
>>>>>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>>>>>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>
>>>> If you update your liburing git copy, switch to the ring-buf-alloc branch,
>>>> then all of the above should work:
>>> With master liburing branch, test/poll-race-mshot.t still crashes my rp3440:
>>> Running test poll-race-mshot.t Bad cqe res -233
>>> Bad cqe res -233
>>> Bad cqe res -233
>>>
>>> There is a total lockup with no messages of any kind.
>>>
>>> I think the io_uring code needs to reject user supplied ring buffers that are not equivalently mapped
>>> to the corresponding kernel pages.  Don't know if it would be possible to reallocate kernel pages so they
>>> are equivalently mapped.
>>
>> We can do that, you'd just want to add that check in io_pin_pbuf_ring()
>> when the pages have been mapped AND we're on an arch that has those
>> kinds of requirements. Maybe something like the below, totally
>> untested...
>>
>> I am puzzled where the crash is coming from, though. It should just hit
>> the -ENOBUFS case as it can't find a buffer, and that'd terminate that
>> request. Which does seem to be what is happening above, that is really
>> no different than an attempt to read/receive from a buffer group that
>> has no buffers available. So a bit puzzling on what makes your kernel
>> crash after that has happened, as we do have generic test cases that
>> exercise that explicitly.
>>
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index cd1d9dddf58e..73f290aca7f1 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -491,6 +491,15 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
>>  		return PTR_ERR(pages);
>>  
>>  	br = page_address(pages[0]);
>> +#ifdef SHM_COLOUR
>> +	if ((reg->ring_addr & (unsigned long) br) & SHM_COLOUR) {
> 
> & (SHM_COLOUR - 1)) {
> 
> of course...

Full version, I think this should do the right thing. If the kernel and
app side isn't aligned on the same SHM_COLOUR boundary, we'll return
-EINVAL rather than setup the ring.

For the ring-buf-alloc branch, this is handled automatically. But we
should, as you mentioned, ensure that the kernel doesn't allow setting
something up that will not work.

Note that this is still NOT related to your hang, I honestly have no
idea what that could be. Unfortunately parisc doesn't have a lot of
debugging aids for this... Could even be a generic kernel issue. I
looked up your rp3440, and it sounds like we have basically the same
setup. I'm running a dual socket PA8900 at 1GHz.


diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index cd1d9dddf58e..7c6544456f90 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -491,6 +491,15 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 		return PTR_ERR(pages);
 
 	br = page_address(pages[0]);
+#ifdef SHM_COLOUR
+	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1)) {
+		int i;
+
+		for (i = 0; i < nr_pages; i++)
+			unpin_user_page(pages[i]);
+		return -EINVAL;
+	}
+#endif
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;

-- 
Jens Axboe

