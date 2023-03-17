Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2B66BDE72
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 03:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCQCJx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 22:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCQCJw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 22:09:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A428CC655
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 19:09:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so3488054pjt.5
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 19:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679018989;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VlMkNFbEmvI/+HqUrxY+scK9VTsFr10P4i942Mg/vqo=;
        b=EVkprxZhagGRJUiijJ/yyFvfEjt7bUbJW6I8BMXYyAXxhY6/UwkVvMT1aIcD7pT8YU
         K1kJtVGE6FbOEyHJ+ACqUUFvDuqTUrDzRAZYSNN8QJ9TMI+uiEHBF+LpaTtfYk7CGT16
         XYs/9Z8Zmd3myvOcMYcZsuCSp1ytxSNSbGgJaMSM53F+DJAIbaILZPwQI0NTtJVtRse3
         xvzCKqi8egp7mCbQJBC2+vvThcGIqDbQk3Vz/m01HfLytPqRdMgpa55ePm17+hp7EdTn
         Dxeu8432hhIdRqWtXsM4Y2WkTGqMZKUIo8MJbyj5Aq6gpQ+oCWQqIH7RMInNlXNoV4wH
         oCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679018989;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VlMkNFbEmvI/+HqUrxY+scK9VTsFr10P4i942Mg/vqo=;
        b=uO+07ASUbVNAJf3y0me5IXLELRpypOSF5vdH/EQczboA2OLTLs9z3gEJx3OaawSe4j
         zLn5xnkfkdLeaXf3NHDNwzlBrfGSN6hiZGyARwaOBlMR3BVEYDROi+Hh4aeSKbopkZgL
         4LFTcpm/7qZEAzx4KKrPB9QP6jQeBgUZQ15Dkb3u7e5CatBhLg4DtQkLVpPQ+mcCeIn2
         tE//zI0ARJa3uNZjBa/NDk4VwB04wM/0MEONTTFTYK5XfvTAGEfVV3W/V1XcAFK3r+7v
         FonV0L3Nrcy7VYYKwv9uJc4cA3wMBdA8+lAUgVPKyEqH1lZhZBv9PoOdj5Qt72NcAXeU
         iZ+A==
X-Gm-Message-State: AO0yUKXyjN4EtJsGUjz0mz7tRL885PaxvNiq+6tKsna8qxbUttWFTvIF
        I9ORC/edqGLyhYaymDcsJOjUeg==
X-Google-Smtp-Source: AK7set8XNZu4aol1nbZVo7Us0wKsRq5izrynF6i/7SL8GrfoZRFF9gqGftix5kpWr1E8nzvDZSHKFw==
X-Received: by 2002:a05:6a20:7f8c:b0:d7:3c1a:6caf with SMTP id d12-20020a056a207f8c00b000d73c1a6cafmr3266880pzj.2.1679018989014;
        Thu, 16 Mar 2023 19:09:49 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m15-20020a638c0f000000b0050bf6f246edsm321599pgd.3.2023.03.16.19.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 19:09:48 -0700 (PDT)
Message-ID: <42af7eb1-b44d-4836-bf72-a2b377c5cede@kernel.dk>
Date:   Thu, 16 Mar 2023 20:09:47 -0600
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
In-Reply-To: <29ef8d4d-6867-5987-1d2e-dd786d6c9cb7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 1:46 PM, Jens Axboe wrote:
> On 3/16/23 1:08?PM, John David Anglin wrote:
>> On 2023-03-15 5:18 p.m., Jens Axboe wrote:
>>> On 3/15/23 2:38?PM, Jens Axboe wrote:
>>>> On 3/15/23 2:07?PM, Helge Deller wrote:
>>>>> On 3/15/23 21:03, Helge Deller wrote:
>>>>>> Hi Jens,
>>>>>>
>>>>>> Thanks for doing those fixes!
>>>>>>
>>>>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>>>>> One issue that became apparent when running io_uring code on parisc is
>>>>>>> that for data shared between the application and the kernel, we must
>>>>>>> ensure that it's placed correctly to avoid aliasing issues that render
>>>>>>> it useless.
>>>>>>>
>>>>>>> The first patch in this series is from Helge, and ensures that the
>>>>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>>>>>> there.
>>>>>>>
>>>>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>>>>> ring mapped provided buffers that have the kernel allocate the memory
>>>>>>> for them and the application mmap() it. This brings these mapped
>>>>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>>>>
>>>>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>>>>> there are others) are impact to any degree as well...
>>>>>> It would be interesting to find out. I'd assume that other arches,
>>>>>> e.g. sparc, might have similiar issues.
>>>>>> Have you tested your patches on other arches as well?
>>>>> By the way, I've now tested this series on current git head on an
>>>>> older parisc box (with PA8700 / PCX-W2 CPU).
>>>>>
>>>>> Results of liburing testsuite:
>>>>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>>>>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>
>>> If you update your liburing git copy, switch to the ring-buf-alloc branch,
>>> then all of the above should work:
>> With master liburing branch, test/poll-race-mshot.t still crashes my rp3440:
>> Running test poll-race-mshot.t Bad cqe res -233
>> Bad cqe res -233
>> Bad cqe res -233
>>
>> There is a total lockup with no messages of any kind.
>>
>> I think the io_uring code needs to reject user supplied ring buffers that are not equivalently mapped
>> to the corresponding kernel pages.  Don't know if it would be possible to reallocate kernel pages so they
>> are equivalently mapped.
> 
> We can do that, you'd just want to add that check in io_pin_pbuf_ring()
> when the pages have been mapped AND we're on an arch that has those
> kinds of requirements. Maybe something like the below, totally
> untested...
> 
> I am puzzled where the crash is coming from, though. It should just hit
> the -ENOBUFS case as it can't find a buffer, and that'd terminate that
> request. Which does seem to be what is happening above, that is really
> no different than an attempt to read/receive from a buffer group that
> has no buffers available. So a bit puzzling on what makes your kernel
> crash after that has happened, as we do have generic test cases that
> exercise that explicitly.
> 
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index cd1d9dddf58e..73f290aca7f1 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -491,6 +491,15 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
>  		return PTR_ERR(pages);
>  
>  	br = page_address(pages[0]);
> +#ifdef SHM_COLOUR
> +	if ((reg->ring_addr & (unsigned long) br) & SHM_COLOUR) {

& (SHM_COLOUR - 1)) {

of course...

-- 
Jens Axboe


