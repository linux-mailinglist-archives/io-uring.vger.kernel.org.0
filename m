Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA0C69870D
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 22:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjBOVKd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 16:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjBOVKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 16:10:19 -0500
Received: from cmx-torrgo001.bell.net (mta-tor-002.bell.net [209.71.212.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCCA42DDA;
        Wed, 15 Feb 2023 13:09:43 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63EA076D004A697C
X-CM-Envelope: MS4xfJNsDnr37Eh1HzT3RHo5XBN18bL9kV0d19xl5FZdsWfasAe91zGd7oQetfPRJAUh2AbFgyZMGmmI9EgW4rSo0ORfAjuq+cN6WHAuczph6BfzwJO6FZb3
 eGHmFLDpD94GUhpjN5CfJa3Pf7ZkUxpevuA1EsMsIrm+r0XNqm8JyhqN0UP9Atq+PSjlWc/RIt4ckWFeO9ezai9zeGuTQwG5j6XR0TaDEim9P5J5ib5kxfOp
 lcbBeQndMeoFAj2/9JcyUXVkA3SUYS63e136l/aBjA3K8Bd/MRiACQmj4SrzkI/aMyuKPDrvi/yxNfmKfraHL4inU2+pmX7Y/k6HH1A5p74yF6hgikncuTsb
 iheWCA9h45FiDgpauMD973isIPDu7SSbQ1fHeZYrPrFCUCZGLKE=
X-CM-Analysis: v=2.4 cv=M8Iulw8s c=1 sm=1 tr=0 ts=63ed4963
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=AWM67kzqNtlpvsr-7ocA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63EA076D004A697C; Wed, 15 Feb 2023 16:06:43 -0500
Message-ID: <c7725c80-ba8c-1182-7adc-bc107f4f5b75@bell.net>
Date:   Wed, 15 Feb 2023 16:06:44 -0500
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
 <4f4f9048-b382-fa0e-8b51-5a0f0bb08402@kernel.dk>
 <99a41070-f334-f3cb-47cd-8855c938d71f@bell.net>
 <d8dc9156-c001-8181-a946-e9fdfe13f165@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <d8dc9156-c001-8181-a946-e9fdfe13f165@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-15 3:37 p.m., Jens Axboe wrote:
>> System crashes running test buf-ring.t.
> Huh, what's the crash?
Not much info.  System log indicates an HPMC occurred. Unfortunately, recovery code doesn't work.
>
>> Running test buf-ring.t bad run 0/0 = -233
> THis one, and the similar -223 ones, you need to try and dig into that.
> It doesn't reproduce for me, and it very much seems like the test case
> having a different view of what -ENOBUFS looks like and hence it fails
> when the kernel passes down something that is -ENOBUFS internally, but
> doesn't match the app -ENOBUFS value. Are you running a 64-bit kernel?
> Would that cause any differences?
I'm running a 64-bit kernel (6.1.12).

I believe 32 and 64-bit kernels have same error codes.

I see three places in io_uring where -ENOBUFS is returned.  They have similar code:

retry_multishot:
         if (io_do_buffer_select(req)) {
                 void __user *buf;
                 size_t len = sr->len;

                 buf = io_buffer_select(req, &len, issue_flags);
                 if (!buf)
                         return -ENOBUFS;
>
> I don't see this on qemu with the 32-bit kernel, nor does it happen on
> other platforms.

-- 
John David Anglin  dave.anglin@bell.net

