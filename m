Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79165698460
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 20:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBOTUa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 14:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOTU3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 14:20:29 -0500
Received: from cmx-mtlrgo001.bell.net (mta-mtl-005.bell.net [209.71.208.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43D33B3E1;
        Wed, 15 Feb 2023 11:20:27 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35DF700BEC427
X-CM-Envelope: MS4xfAARORjqIfdSPonFVgFUGTcAf4T/hhE1Rock6PxEFI2dt49qPCfXGTFo3vakCiTjO4GJuoFGaU9Z90o+avri6Zze2okkOY2ji7itqAz6fzjJBDO+GHeZ
 /S16R6MlsilCl9LXPjvxFZ7gB/W0KUg2wZxYab2wpFEbw+9jP3e4wMdD7TwoM75nKGIz6I1vhjDy5Pnj52z0X3Xzp2sG2IUC/3LHQoizTc9UD+HWfKiwvjm3
 RR63HfXC1anMy5401pGohqAmNTEGAsgfDhPxZuceuz0fNsir4bnCnzE7cdfVXVnrI16quAjnLd3b+PeXM0JB7alPYqmGKV3WO4rjQlXoa7V7RsLG4kmkF8yA
 Zfmd86UmkQkIt5vKXyeTfrwYAglHjKTOuvA2eiMJ3+dHp8lmTK0=
X-CM-Analysis: v=2.4 cv=AuWNYMxP c=1 sm=1 tr=0 ts=63ed3078
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=dwGdP2CtMFE-EeT_xoQA:9 a=QEXdDO2ut3YA:10
 a=ATlVsGG5QSsA:10 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35DF700BEC427; Wed, 15 Feb 2023 14:20:24 -0500
Message-ID: <f6bbfb33-67f6-6059-6111-b9e02fa30e0a@bell.net>
Date:   Wed, 15 Feb 2023 14:20:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Helge Deller <deller@gmx.de>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
 <a03d75b9-a9b8-b950-c53d-6df85fe8adc4@kernel.dk>
 <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <07810314-94f6-0e9a-984b-0a286cbb59d3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-15 2:00 p.m., Jens Axboe wrote:
> accept.t: setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
> fails here, no idea why.
The socket call fails, so fd is -1.

-- 
John David Anglin  dave.anglin@bell.net

