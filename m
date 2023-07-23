Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F3D75E1B9
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 14:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGWMLg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 08:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjGWMLf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 08:11:35 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F9B1BF;
        Sun, 23 Jul 2023 05:11:31 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qNXvt-0006o4-EM; Sun, 23 Jul 2023 14:11:29 +0200
Message-ID: <03b96f88-559c-454a-702c-90b0ca50b3b6@leemhuis.info>
Date:   Sun, 23 Jul 2023 14:11:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US, de-DE
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716195007.731909670@linuxfoundation.org>
 <12251678.O9o76ZdvQC@natalenko.name>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <12251678.O9o76ZdvQC@natalenko.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1690114291;ae7eaa41;
X-HE-SMSGID: 1qNXvt-0006o4-EM
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 23.07.23 11:39, Oleksandr Natalenko wrote:
> On neděle 16. července 2023 21:50:53 CEST Greg Kroah-Hartman wrote:
>> From: Andres Freund <andres@anarazel.de>
>>
>> commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.
>>
>> I observed poor performance of io_uring compared to synchronous IO. That
>> turns out to be caused by deeper CPU idle states entered with io_uring,
>> due to io_uring using plain schedule(), whereas synchronous IO uses
>> io_schedule().
>>
>> The losses due to this are substantial. On my cascade lake workstation,
>> t/io_uring from the fio repository e.g. yields regressions between 20%
>> and 40% with the following command:
>> ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0
>>
> 
> Reportedly, this caused a regression as reported in [1] [2] [3]. Not only v6.4.4 is affected, v6.1.39 is affected too.
> 
> Reverting this commit fixes the issue.
> 
> Please check.
> 
> Thanks.
> 
> [1] https://bbs.archlinux.org/viewtopic.php?id=287343
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=217700
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=217699

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot introduced 8a796565cec360107 ^
https://bbs.archlinux.org/viewtopic.php?id=287343
https://bugzilla.kernel.org/show_bug.cgi?id=217700
https://bugzilla.kernel.org/show_bug.cgi?id=217699
#regzbot title block: io_uring: high iowait rates and stalls
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
