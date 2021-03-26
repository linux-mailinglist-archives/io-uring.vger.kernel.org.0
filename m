Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B407234AA8E
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhCZOxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 10:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCZOxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 10:53:09 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF76FC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:53:08 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id j26so5621435iog.13
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NXuRAzdKEe7N5IQQl9xMaaIUvBWdEBQEbrAPEIQ9aXQ=;
        b=L1c239beA0XBmspjlf3y3HTn9Z9nSwHses5P2ve269y9Unj7cktKPCwBrhu49QIUl5
         Av2iihOObkQ6ymlCFAaKtP03ouqEoNUoXf2erXD6Gtk9xvhyXuNZPmLY+qUSIs3fxyyu
         lV6CdQmVAX74ip4lNGNqKf+tgzhu2XAstjvYIL37jlTQAKHqi3VhxeWVQYbTaFdcgrGq
         jOipfo5X6XpEA/FvCHObZ1DYHbACLIRfWRYgSzVOI1Ke0vHIu0QQKAen8sdiX2oqkkwi
         /KPaHiffO323G8N79uYVv8MjciAsxrcCOs1ELgEphitmKlMeRzYFJSpvtH4TrD6kUGMH
         FDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NXuRAzdKEe7N5IQQl9xMaaIUvBWdEBQEbrAPEIQ9aXQ=;
        b=iS+9hhs8PmgYFx1KuXrxfEtq22y2f3lgBANnToYhCWif0Ql/d6O5fJnimqRJG7XWuu
         nY1KT7UpvfgtaGdSmmbzG7eQdxwSupEUPqP4kaAFXNwdxssf3O3Secaxuga7MjD0cEeS
         T6xTDLh3wbRXTc4YiVmyJf4z9oC+l1sABKypF/ClG01Bg5q/MGMDrH59vxfHDRjZJ3XB
         dsyJAR/B+OimELHGYgHTMkeKAA3HgHOpGmEYc4uEu55b0BIPcnDPyHxUpW+FpcM1bDiG
         z5zlvS9BsBhVQLlGLrjJeDJLOABje/mQIj9VqMYUxebFDSGEsHk9ODFsS66Cm9lJwBGW
         7vpA==
X-Gm-Message-State: AOAM530/4kK0t5VH12CxO4BzUR9M38H8B0up80DpAePSuBaGs135L7AN
        5CknI2GFoRKkgxQORvq8EDMaMA==
X-Google-Smtp-Source: ABdhPJzfj750MvDj2ov6f4RiA0vpzH3d69CrBQeQA14UDCb365lt5hu9mqMYknwSLlqfJSAuDJDQSQ==
X-Received: by 2002:a02:cc1a:: with SMTP id n26mr12397597jap.21.1616770388203;
        Fri, 26 Mar 2021 07:53:08 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v17sm4394179ios.46.2021.03.26.07.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 07:53:07 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
 <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
 <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
 <ac807735-53d0-0c9e-e119-775e5e01d971@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0396df33-7f91-90c8-6c0d-8a3afd3fff3c@kernel.dk>
Date:   Fri, 26 Mar 2021 08:53:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ac807735-53d0-0c9e-e119-775e5e01d971@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>> The KILL after STOP deadlock still exists.
>>>>>
>>>>> In which tree? Sounds like you're still on the old one with that
>>>>> incremental you sent, which wasn't complete.
>>>>>
>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>
>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>> pushed), fwiw.
>>>>
>>>> I can reproduce this one! I'll take a closer look.
>>>
>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>> and never return. So we might need a special case in there to deal with
>>> that, or some other way of ensuring that fatal signal gets processed
>>> correctly for IO threads.
>>
>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
> 
> Ah, we're still in the first get_signal() from SIGSTOP, correct?

Yes exactly, we're waiting in there being stopped. So we either need to
check to something ala:

relock:
+	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
+		return false;

to catch it upfront and from the relock case, or add:

	fatal:
+		if (current->flags & PF_IO_WORKER)
+			return false;

to catch it in the fatal section.

-- 
Jens Axboe

