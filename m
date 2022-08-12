Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D041A591368
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiHLQDT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbiHLQDS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 12:03:18 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com (sonic309-27.consmr.mail.ne1.yahoo.com [66.163.184.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44F99F0F3
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660320196; bh=ar67XpiKs5jUstnS+Wuku87KNcIwPcCRu6ic4WVpGc8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=BzzjZtWsGUopuAwlXkAtq0qBKuibV1cO9WNKN0SVlbx0deBCHsljJS+Au2PUoO5v3mIFdFLttM6t0Dype5kX0cKkj39izVoCEJMo0Ronxovc1fR8Q5A1tlKaoa1/4WunRH2nT6oj1tY5rCR4dNmTmxmqLhfznCbGgUtClsldibq0E2cZA53NrQqgaHPRrobgQPdY7wdLzAeWpe9GjbxNEPE/br4cUEiPLjPza/ZVeugbVKK4xLx2y3BwUvpER0Hz+rS69jdyhtDrpJPKiJ22/m1s/YGXnnvW1+R0uDjUb3aSsU9+6Emw/UPUSkf2ZZxXh6cQsYrJb0BV9a9JCZTaPQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660320196; bh=PhVy4ByZnIW5Vj6k7DSaC2F+6QO5P3PDUqHteAuV44Y=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=B5IS1RgFNQ6jZueCDMDd76pL+tlhAem+OQshvkee3KvZZrVceNML/oEXAcDer/zvhKILmgRWHLKeJnOpFAuK22W4JHjZiHoctbHZqqzBx3kasf9hMuqje6M/z3xXTIzddW6nv7z9XAlCgU0yCRS1edeNqe+96sa1YPjmCbFSaBp/rcfBg79eHZ8WATawV4zxvHvd27TSGaHrU1emQWydQIas6PH3fzoGFMtZXkqI8zsxCDOuAeXhFTZXyrPnwvG7n+zmv0pp1pVAs5qVCNw1vxn6malKXwbe7WoP/lv898lICM6jVM35O3N1wGFDdAp2sofnfdLFN/248cDEGyEXbQ==
X-YMail-OSG: U7PIn9IVM1nWLz6UfTncvkqQM85kO.slRjMZ9pQ6bwL9yNbKgEh5cBSQqUeVNNZ
 4PWsq7whO2UFdbYYJxazwHM2Sp.aN2WFfrKwqQe.bG07JWGayFvPZYyuJgm3c3jegtjqPNIojud6
 pQPqJjfTY4MSWfqM4Mq3N3p5CLg9e6.5ahkvcODBie4UoPf_GiRQ7X9zcl.IJvdqo.3IgbRCGUJy
 nwYtVjDINFygvNuCmjQJtulqFY43DNPTkRfv9q.AvW91tMibPqdZOk_0FnHHtwxQPU9Snw2qjAir
 eaXJ_nu9JU0AIdlT3P5c7wszZB2sHHCHqFFGc.Mk9WL2xLau9001.c9gaQ3EYHCI7JJv9c8FKpPy
 lShic8kn3RY28Kya2Fr4u2Rv8uz.kUN.QZjyeQ943MLD01YHlr0tzfRb1l0zP7oO6yLwaYB9Hsgb
 InutfE0uKL_MkiyriZbp2gIUr.uJdUNJ__398XVTSBzt3W6HKKhjITEf.r99dFvhDhYTl_SQVEZr
 GpHP7zkQgqVeQxgtnYIKozQxnQP7a3UVDu_S6o0cWkhRZ7MmgPP4fEjvi9RIZnZDPmBbjoEfz_rq
 T5T9rA7M9gLRxeUumBtbWe5CxZrn7GbFvUwyd3TyvtXp70uG3vuwSrJo4NwVxAdXF73YQpbItW1g
 koQFseEJ2ajXhsAeqL2PZ5WzUDc2e4eCJ6B_At3L95pZvW23XJMgSecVMEyM.DxsL5JEQIWVmzHo
 0mCCpPjEzDVK1BNYkaI53f_vge1p2nNamLZZDk8syF9twFrqUXcDWD1jjx0wpKp0fhrWdtJoJPBI
 xn1MljjSrk6vpHRbxdQutldrpUmvT05NTso_KtrnctiBOX9at.6oq2.RcYDD_9fXAIl9H1VxmUnl
 mjhwhA56vBhsxr._6S34f0me_FVqXQM4H4LCRAg_ruFP4C5ADmYBTo0UKxSIEocKeodC7VFBDTev
 G_FoiyqIiUJi5jBrQIibgYNg_WSBkzvssQzZgozDi5tia8wBjJ70XADx.Co.3y7vBAqS3PKeoYhw
 qPFHAWDaBYe.OnYnJumgPamIJ0FytOF5mtRrziJ5gbCodrSSX0EfRgE6Uu4edFri4Z1GqKq6GQv5
 GWMwYbAeVujzA_5T0hgRh7tl4VDd7adaRTEMaEkZttqUj97x7IVlGWh5udfg59TWWyaqvfMcxfwj
 3PmOHsbVepQL6eGUHwFRAKSWU33G0L._N5HzsdRCEyHZl8.MaK22fDZmsoj3HXwxpddIRbPtXhzm
 gYPDmP6gJvH77yqP4_6oycnp.Th8wvFm5XFrmFwX0Qp4cMIjn9zrHlJaVOE3cIA5GSIMRFGFPSbo
 mpKtZha6O2cygRKzTyRTZhSgiYRqlMJAWwuy0ewvoPX3Vwph6z6ST.u1Mefh0ep3siyu33eqYdZh
 asYiA13bkQKmNsK8y6.gK.ZLerZN.AKbHqa2AQwW9so7TmaWdmG6J3ySQ1jOg10H3uAvJqemkszk
 I8fDtbK1_3JcOBSVRKFUTMgRM6H9jupd7na5kiCq4sCY4N3fvtAL1n5pTgg6YEf0R6PnerK21X08
 sXfAWo_RpicTIWzIUmfukSqyOnmZY4QyPB5O05co4DZMFeJuExQho..LrTI2bTdYZ51Zhee_bdZR
 cgQpflwhoRWPfi.WFwd6cjgmZ3l0Zj_qTMRN1.sNZAk0B1hJS3lBOCy2XwyM7uBLfX1UdalY2r5F
 oT9Oy973jHeT0OFP8UtQ9ih4f9esZ7e2vwL_bAJ5DeqVEEtxTpXIupXaPDH2G5iUyS2u2i3biYhH
 L93dKDOk8oYsFvVTjMtreECMjl97ybNKsDYTzGbFUvFS7b52A.gQsZjVCvNksFkq7xcAnvypih7v
 zP._ogWYLT9Fp0aXDwdJ1hmVUNxx85d1ZzmH89IVcBU3.nqwVSSWbVw1JutH1nfFz1DZdvd9iG0W
 84Ud4hd1mIdxOqkOHo9HD7qflT3uqZIrLMbh.ETFePVI1LZzkI.rVbCIV04o8pM8X.nqmojN_Y6S
 L1dPI7owMp6w_XeVOrUnePE5fU04A.azkLA5w1GZRS4RiKkgIfBKcpymMgkijJldfl3hXTBi4yU.
 MpT7Ywcwq8.p8ggWGvrsTQmeRwixoxwuMVARXuLZoO0fT.v7j3PZtchZCQGLkJMxcQjccUK7ZhqC
 tNkZxkLr4OTVBoim50mQVFDZX0TDOkiDVBC_UovRMqoix2xJXyCjzFB.FZwcd_aRXhBcoHd2Y9lj
 S7mnA4C1mfZAYq0qLchgdyq3hUFgBEdWsaBX2pLVRg0IiehQF8QBhlVXGvFkvYbtu1vrRFb9imtZ
 5HE4EpEv0uxI4z1SPYpjtEQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Fri, 12 Aug 2022 16:03:16 +0000
Received: by hermes--production-bf1-7586675c46-4x8tg (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID a9013da29ef145efabdb73869e50d767;
          Fri, 12 Aug 2022 16:03:15 +0000 (UTC)
Message-ID: <6e90dc31-e4bb-b5c4-6e8c-112e18f3654f@schaufler-ca.com>
Date:   Fri, 12 Aug 2022 09:03:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH liburing 0/5] Add basic test for nvme uring passthrough
 commands
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, io-uring@vger.kernel.org,
        joshi.k@samsung.com, casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20531 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/2022 8:33 AM, Paul Moore wrote:
> On Thu, Aug 11, 2022 at 9:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 8/11/22 6:43 PM, Casey Schaufler wrote:
>>> On 7/19/2022 6:52 AM, Ankit Kumar wrote:
>>>> This patchset adds test/io_uring_passthrough.c to submit uring passthrough
>>>> commands to nvme-ns character device. The uring passthrough was introduced
>>>> with 5.19 io_uring.
>>>>
>>>> To send nvme uring passthrough commands we require helpers to fetch NVMe
>>>> char device (/dev/ngXnY) specific fields such as namespace id, lba size.
>>> There wouldn't be a way to run these tests using a more general
>>> configuration, would there? I spent way too much time trying to
>>> coax my systems into pretending it has this device.
>> It's only plumbed up for nvme. Just use qemu with an nvme device?
>>
>> -drive id=drv1,if=none,file=nvme.img,aio=io_uring,cache.direct=on,discard=on \
>> -device nvme,drive=drv1,serial=blah2
>>
>> Paul was pondering wiring up a no-op kind of thing for null, though.
> Yep, I started working on that earlier this week, but I've gotten
> pulled back into the SCTP stuff to try and sort out something odd.
>
> Casey, what I have isn't tested, but I'll toss it into my next kernel
> build to make sure it at least doesn't crash on boot and if it looks
> good I'll send it to you off-list.

Super. Playing with qemu configuration always seems to suck time
and rarely gets me where I want to be.

