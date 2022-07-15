Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B11575914
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 03:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbiGOBZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 21:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiGOBZL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 21:25:11 -0400
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7FF60518
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 18:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657848306; bh=9G7en9OvLW2IyJsMzHYkRz5BlSpr0HNz5y6GycQ6mho=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=B0yMJtbJ0cQiIatHXowWrqpMR/yWDTiaEPlZsIwnw1ZKLUtC7W2tePBUU8mh9BqS+CU70t4P9nC/V71YHtTy35n2avYHkfR+SjTACroEAwZmwoaIEP73Kj3r0jl9TQRvnPDX/DNeoW9O/L697q+almbeJFryQrymF76G0gpdauCQ1/PJsTnK2XgSzBXqcdXD84sV4i+7jOCPWixWN3dpvvBM/3v4iTk80PSj4A1fLAboLwKzxrnhirnfg4cz07Nrqbc+igNwquYcnqKbD/968jdDbtHEE/Sw+r2iREdVkIBDX95iXOGKMr//JxHen3dE4R6tkLrqOm0rCAV8do2dRA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657848306; bh=U5jsK1GpG8o64IwvxbLuPUnZxuX3FhSb6EWFCFdc/Yv=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=FKJUPfQqV2aRM0CHd2lvhVxxVHR7Aa0dEm+ESk4Ivxf6IPXlDuVZ8vmuETUhLwl+MFrnVok/rB8xx2P3O5zq/0Sro8Qh4EtKqfUylO7K5wvPlHRtaXh8nsxp7Rvc9nghGBIW/PamVH2kqmt9eWZYdrqYI6sNVVgR8W8hCHYYOCcOoqr2NBokXsMEbgYCx3UXrnQBpLFdjFqDH4yVVU3kwByZMKAq1pBO+eyGTy584mDECuOY9u6AZD3R9QXmJ8CbWafT7V8spq+lJrBLuRX1rixRN3oMBDGy8IqReEYJfB7PBepn0csCllhj3BKObsvCK4A5rj1Fj1HW0XmFDkuyjw==
X-YMail-OSG: feU18OgVM1nZwHpYWMAAAgqxaTR6U32xLaAec_q9TzoXcwN30bMO9xArgaLS8bz
 z1npN8_s._LkzREpNUw0ZMNMv4QKrgukZOXkvSFqYF3PS5tWFnL4byTGMcj9MbfMhJwhmX.JzrNc
 UTq6.wNZBUhySOn8wBDHvxHlerUk.fSghGrdKUb.CzPl54zzajP4mjlKOYsXtXjPerduh.yqkQ9w
 NFbe5S26TaAuWJe5P1.kyMuZ6RgkxY1cG8MXbqCnd9YzrZ4MEpAV94otLGku8mcPidXDyumpS1oi
 CDu93JXSjtPr98iJBbdBK5NvYcoj.ILzRALFFyA9gMq3hT4ker2mqBVAbWJTFdQBso.cc6vuPgJu
 .2cqkM6pdR6hSLSj97Vv6iGtCIQh93HjJvJobxgZ_orhTKcLv37ujwATF7kEfNd6X1NJurUABIz9
 HZaSBzfwNMSzQ_JqmQmk7jJO8W5aAcNkFM.eR8yYXgISAg0JlOE7OauHjGwHWMvEWKRgqIv.I5Io
 G96L5q17itvRdHvIrnAmydexBJWOVgEgtyKIxGX8ppBndf3solw09hRQeM_NAYFmVw3e5qTKYJzd
 IJpcl0mEoW13.MHa6.8J8Fhog4VT.on8A09Xv4gH2ctTJNfBdtak2WVRN5ry6VE2PavCABjEy3kv
 aWkq.KfdycTMXf3ONEVlykLVAP2HmLrqwdCvfJv3sMxnOWVW9fgTVHO.wZvN5k.dVgKk8O1ThlTj
 HWWLJynPDx6TeJlHu5C1bq8NpxaWg54i6Cz38_UjgdH.sVvoBXEWFy2qvUcDuKECCAms.qsOuMG1
 5sQEDfS0XtZvGjVnpq6BtyZlfg3EyL0KWyVaycTpr5bn08acN08_1dLHJXXUNgCRqlil9GC32.PU
 oH3.ORn.e7T8ykJ3hMA_OlpV79H9y3KNAIcuwigHRNQRFbX6_bpUmQhW652Q8U3Ecqe1QV30Qf5N
 vl8vwSGvUs0XC34QPA8zd2025W.ZGGElsvUS0gmsJ8JJHcyB1GT_FhEagcaRWjNQtxx8rHWQTt.j
 AYVzCqTilpAziCQagkK9_2JipNQ0IOnQs1Ih.I2rhIPqnJf9vfKyiEOU3C_xxiuYtCZCmEcFQiWy
 Us6Due61bkm2BUfo5kViZOKhG6LbevPRjFDufPi0WVqxfHiFcegKnD2PSUwXM4RwmsZtOEb_Ierf
 WCtCQhOGHkfoXi3rnoQr3w.r36n0fdzy2amDyz5aYDjjXuxgA3DQYo4L2pht9kaMSdfPpExOFxgr
 9JbRpvvEn34W9xVY23Y5.ovFxhXvp9Tq5ukgBNA6QHF.aYEIu15cs0NFawSO15eb575f_SjWZES4
 CqS4iiv_9ckJOGVVixlTJ7Ao5DyS0A3a5.NzsKF2ppdqmKc1Eb0Twz2k8KfC6qmdJKZ_Vew432Zs
 _rpfpmvINu05QD92vZze2D6pIh35IhnfjhLOqbt1ULhAdIlUrsR0J0fy1lUJb7DleIRxEczY6gQX
 LFy1FFC4e81imJEd2bAVurnrJdPlqs6pJ8vfmzJs.don77I9mTzoBzx_Padb16DU28S0CeGlqNPp
 .Kj0iFqfgZOR_uvi0ElekBIcK2aAgfWkE8NLWaC41jd4diUy8LbHqrBbEc5xf.1jwG8w8rHUTwjF
 gy9uXXfGfTzfdxCKtAys..ssbDF2B6q1XZZRPT12aM7vB3TSIe3l1SYOtPxXkV7ez8MAcjEwdR1f
 pdDBlAthmgk1VbRGjIUPqsCSSlQxgPAwnaFlWq7MQzRQprvvEhGTRgPWcp75EiHKJRt4_vxH_o0.
 JF0SVor6Or7iFP0NSyb3BHe4CUuzjOCNBza2c85JPwA29SUBXsy1nP8JmnvwmURwVptii2g9i1vH
 vDh5AG4dX5baUaxqbMxA8RBNiE0nqTHHvLkqaL1DyCHT7r8Z8SpSX4qd4qOQpEgBjN0pOG9Blnpc
 u6kgAwHgGMHrrunV3PCQbCRTzhSND3Sk_GvcD3B6nZXiE3527NP__95mVXik3RLMYnYKwiPb_Vx7
 tKLZIxn6fqBxGBXxis.uFdK5LgePyqfll7BoNPF8.r6QxHMVnJjZKxYm4cryKsbORHzeQW2UVUFK
 MU0Z6jpkXPRGV7lycBk7hWK2Kumv6.O.vIOSuPv_e99s1XdkLPAJqoEwxWyNBsgyYnIG3iQU1y4f
 axuSnSeVaF1M3JtHjA8umolZZQrJLtKjVJlNbHastwTkF8yamp7hty6zj3WqOjmyB7DfHmY3jc9e
 qv_xKAB39df7b.0sntBl46N_hOxQg5JjLgr4-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Jul 2022 01:25:06 +0000
Received: by hermes--production-gq1-56bb98dbc7-28prh (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7c14d55f1cf0ce6fc421db272bcd815c;
          Fri, 15 Jul 2022 01:25:04 +0000 (UTC)
Message-ID: <be4ec1e4-89c8-9a1c-bb2e-6f158312270e@schaufler-ca.com>
Date:   Thu, 14 Jul 2022 18:25:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, paul@paul-moore.com, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com,
        casey@schaufler-ca.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <30dee52c-80e7-f1d9-a2e2-018e7761b8ea@schaufler-ca.com>
 <YtC6wT4CYq0an/vX@bombadil.infradead.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <YtC6wT4CYq0an/vX@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/14/2022 5:54 PM, Luis Chamberlain wrote:
> On Wed, Jul 13, 2022 at 05:38:42PM -0700, Casey Schaufler wrote:
>> On 7/13/2022 5:05 PM, Luis Chamberlain wrote:
>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>> add infrastructure for uring-cmd"), this extended the struct
>>> file_operations to allow a new command which each subsystem can use
>>> to enable command passthrough. Add an LSM specific for the command
>>> passthrough which enables LSMs to inspect the command details.
>>>
>>> This was discussed long ago without no clear pointer for something
>>> conclusive, so this enables LSMs to at least reject this new file
>>> operation.
>> tl;dr - Yuck. Again.
>>
>> You're passing the complexity of uring-cmd directly into each
>> and every security module. SELinux, AppArmor, Smack, BPF and
>> every other LSM now needs to know the gory details of everything
>> that might be in any arbitrary subsystem so that it can make a
>> wild guess about what to do. And I thought ioctl was hard to deal
>> with.
> Yes... I cannot agree anymore.
>
>> Look at what Paul Moore did for the existing io_uring code.
>> Carry that forward into your passthrough implementation.
> Which one in particular? I didn't see any glaring obvious answers.

Neither did I! I'm still playing catch-up on the initial io_uring
implementation. Smack's "Brutalist" support for io_uring isn't
especially satisfactory, and adding arbitrary sub-system defined
command behavior on top of what's already pretty mysterious
isn't going to make it any easier.

>
>> No, I don't think that waving security away because we haven't
>> proposed a fix for your flawed design is acceptable. Sure, we
>> can help.
> Hey if the answer was obvious it would have been implemented.

And it still needs to be implemented, even if it isn't obvious.
In the security world we don't get to say "Sure, the performance
sucks, but the optimization folks will take care of that later."
Throwing in a nebulous security hook and counting on the LSMs to
make rainbows out of it isn't going to fly either.

>
>   Luis
