Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD00475BABB
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjGTWjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjGTWjw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:39:52 -0400
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7EB4E65;
        Thu, 20 Jul 2023 15:39:50 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=VRCOnIUN33GD4S/kz99MMHBca1UpjYhSJAE2NXKYHMQ=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20230715; t=1689892786; v=1; x=1690324786;
 b=Pvbsz7/iDEPJKzRlTeHB3Q4Uq7oLO+zwY69mdzii4Enz24QFsFM1q8XXS+gTfmpnOVpwI+b/
 mIUgqUvxB4i7RHFgNcRhydwjlIm3FLFqboBf74RR7Iy9Uuo5LcLj/twaIjDw7ApwCSOfGcO2F7J
 D2Ql9Qn7vQAhsOO7DpZv3ZqgGM2E/t+KhF8M/fqxEm3RmRh6U0SdmO2MHAgIX7CI034C6MGFR8S
 Gh7s27YyVx6b3eKkuqmnDiLT8gDmhC9lI3dGQFxI2R9jFMyp953QpKmwL0kimfScCd8Y96NNtnS
 soFKgfuo7cdwgu9pEmvaIvLujvHIcKoS6dSRPR6k4dJeGcfXDq5m5txVunXZn5xjCriRSDNWhhe
 2Fl9xoeihEb3QTGTRCMkevKcnLhswOj/ah69w5mF0kqRhbIIVMkadgxNi7JT8jWdcsrmXTHc1cw
 6nYiOQzdZ5gBgaVEpl1i27g1pRfIAwElRK93YtYsstbOqEDB4MfcpS/zL/KH1pCKNhkLBsBdy8A
 EFDBHbFUopZgK/Va0trgYsbbLEpx2foSWYhzo3H24eag8FI1wasG8c82LnqEDREEQSEYlZ7KtS0
 SpKy9yajSuiWL9T1c9MbAaq/4lC3j0S9M620F8keCBXU+jlSexNlROjbPI+hQ1nq4ne72xx/ACQ
 0UKrDgmGEB8=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id 3babdaa9; Thu, 20 Jul
 2023 18:39:46 -0400
MIME-Version: 1.0
Date:   Thu, 20 Jul 2023 18:39:46 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Helge Deller <deller@gmx.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for
 IA-64
In-Reply-To: <be208704-b312-f04d-4548-90853a638752@gmx.de>
References: <ZLhTuTPecx2fGuH1@p100>
 <0a242157-6dd6-77fd-b218-52e3ba06e450@kernel.dk>
 <be208704-b312-f04d-4548-90853a638752@gmx.de>
Message-ID: <ab42ee876fbab9cf10d6c1dde3164945@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-07-20 18:38, Helge Deller wrote:
> On 7/21/23 00:30, Jens Axboe wrote:
>> On 7/19/23 3:20?PM, Helge Deller wrote:
>>> The io_uring testcase is broken on IA-64 since commit d808459b2e31
>>> ("io_uring: Adjust mapping wrt architecture aliasing requirements").
>>> 
>>> The reason is, that this commit introduced an own architecture
>>> independend get_unmapped_area() search algorithm which doesn't suite 
>>> the
>>> memory region requirements for IA-64.
>>> 
>>> To avoid similar problems in the future it's better to switch back to
>>> the architecture-provided get_unmapped_area() function and adjust the
>>> needed input parameters before the call.  Additionally
>>> io_uring_mmu_get_unmapped_area() will now become easier to understand
>>> and maintain.
>>> 
>>> This patch has been tested on physical IA-64 and PA-RISC machines,
>>> without any failures in the io_uring testcases. On PA-RISC the
>>> LTP mmmap testcases did not report any regressions either.
>>> 
>>> I don't expect issues for other architectures, but it would be nice 
>>> if
>>> this patch could be tested on other machines too.
>> 
>> Any comments from the IA64 folks?
> 
> matoro tested it on ia64 at least...
> 
>> Helge, should this be split into three patches? One for hppa, one for
>> ia64, and then the io_uring one?
> 
> If we split up, I would prefer to split it into 2 patches:
> One for io_uring together with the hppa patch, since they should go in 
> together.
> 
> The ia64 patch is probably unrelated, and can go seperately. But
> there doesn't seem to be any ia64 maintainer...?
> 
> Do you have a chance to test this patch on the other io_uring 
> platforms,
> without applying it into your tree? I think some testing would be good.
> 
> Helge

I tested this on ppc64le last night just to be sure, still had 100% pass 
on test suite.
