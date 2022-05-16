Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7677B528D23
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 20:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbiEPSeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 14:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiEPSeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 14:34:22 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A0CA1B7;
        Mon, 16 May 2022 11:34:20 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nqfXu-0001nq-QR; Mon, 16 May 2022 20:34:18 +0200
Message-ID: <1ce76b24-9185-6b2e-844e-d6a0ce42bb0f@leemhuis.info>
Date:   Mon, 16 May 2022 20:34:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Daniel Harding <dharding@living180.net>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
 <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
 <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
 <da56fa5f-0624-413e-74a1-545993940d27@gmail.com>
 <3fc08243-f9e0-9cec-4207-883c55ccff78@living180.net>
 <13028ff4-3565-f09e-818c-19e5f95fa60f@living180.net>
 <469e5a9b-c7e0-6365-c353-d831ff1c5071@leemhuis.info>
 <eaee4ea1-8e5a-dde8-472d-44241d992037@kernel.dk>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <eaee4ea1-8e5a-dde8-472d-44241d992037@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1652726061;02ccf4ca;
X-HE-SMSGID: 1nqfXu-0001nq-QR
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16.05.22 20:22, Jens Axboe wrote:
> On 5/16/22 12:17 PM, Thorsten Leemhuis wrote:
>>>> Pavel, I had actually just started a draft email with the same theory
>>>> (although you stated it much more clearly than I could have).  I'm
>>>> working on debugging the LXC side, but I'm pretty sure the issue is
>>>> due to LXC using blocking reads and getting stuck exactly as you
>>>> describe.  If I can confirm this, I'll go ahead and mark this
>>>> regression as invalid and file an issue with LXC. Thanks for your help
>>>> and patience.
>>>
>>> Yes, it does appear that was the problem.  The attach POC patch against
>>> LXC fixes the hang.  The kernel is working as intended.
>>>
>>> #regzbot invalid:  userspace programming error
>>
>> Hmmm, not sure if I like this. So yes, this might be a bug in LXC, but
>> afaics it's a bug that was exposed by kernel change in 5.17 (correct me
>> if I'm wrong!). The problem thus still qualifies as a kernel regression
>> that normally needs to be fixed, as can be seen my some of the quotes
>> from Linus in this file:
>> https://www.kernel.org/doc/html/latest/process/handling-regressions.html
> 
> Sorry, but that's really BS in this particularly case. This could always
> have triggered, it's the way multishot works. Will we count eg timing
> changes as potential regressions, because an application relied on
> something there? That does not make it ABI.
> 
> In general I agree with Linus on this, a change in behavior breaking
> something should be investigated and figured out (and reverted, if need
> be). This is not that.

Sorry, I have to deal with various subsystems and a lot of regressions
reports. I can't know the details of each of issue and there are
developers around that are not that familiar with all the practical
implications of the "no regressions". That's why I was just trying to
ensure that this is something safe to ignore. If you say it is, than I'm
totally happy and now rest my case. :-D

Ciao, Thorsten

