Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597BC6BBE7E
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 22:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjCOVFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 17:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjCOVFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 17:05:45 -0400
Received: from cmx-mtlrgo002.bell.net (mta-mtl-003.bell.net [209.71.208.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883CC4DE09;
        Wed, 15 Mar 2023 14:05:13 -0700 (PDT)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.104]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 640C554900829961
X-CM-Envelope: MS4xfHd5aXtr6YBmVbNj1S4P8+cduTO+k8/LKtW6dI/G29Ca/Pm3KyXwLn/Onol511iEq1jEPe7Z2rzVAxYak5rPVEMqM9XcYH+YNBEkTSYyfjDWzyIZgqmT
 NLv/X/GW6VHiMNLyPhDov8Wv7MHmEWZDB0quLzmqG69asf1xTIl73hxA5HDFBjahTJA6n836n1sEa4bwnYkMxtEIFua/GZv80KRB6XAmw7m+8sF7+1IZ9gZj
 b7NMUys+uFxu35Kn/uFcb1mk0NC2mbptK9Mv/AwIJ0+xn+kI/P6C1toKICaFbxHMkU4qSYt6cuKFy63GB+IwGHnUizm/P16LvxhZfowHpXU=
X-CM-Analysis: v=2.4 cv=GcB0ISbL c=1 sm=1 tr=0 ts=641232cc
 a=jp24WXWxBM5iMX8AJ3NPbw==:117 a=jp24WXWxBM5iMX8AJ3NPbw==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=wHC74J8LaWSo8Lls_4QA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.104) by cmx-mtlrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 640C554900829961; Wed, 15 Mar 2023 17:04:12 -0400
Message-ID: <19dcf149-9ee7-048e-193c-accf297d7072@bell.net>
Date:   Wed, 15 Mar 2023 17:04:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Helge Deller <deller@gmx.de>,
        io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-03-15 4:38 p.m., Jens Axboe wrote:
> For file-verify.t, that one should work with the current tree. The issue
> there is the use of registered buffers, and I added a parisc hack for
> that. Maybe it's too specific to the PA8900 (the 128 byte stride). If
> your tree does have:
The 128 byte stride is only used on PA8800 and PA8900 processors. Other PA 2.0 processors
use a 64 byte stride.  PA 1.1 processors need a 32 byte stride.

The following gcc defines are available: _PA_RISC2_0, _PA_RISC1_1 and _PA_RISC1_0.

/proc/cpuinfo provides the CPU type but I'm not aware of any easy way to access the stride value
from userspace.  It's available from the PDC_CACHE call and it's used in the kernel.
>
> commit 4c4fd1843bf284c0063c3a0f8822cb2d352b20c0 (origin/master, origin/HEAD, master)
> Author: Jens Axboe<axboe@kernel.dk>
> Date:   Wed Mar 15 11:34:54 2023 -0600
>
>      test/file-verify: add dcache sync for parisc
>
> then please experiment with that. 64 might be the correct value here and
> I just got lucky with my testing...
> be interesting to see

-- 
John David Anglin  dave.anglin@bell.net

