Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90ED46988DC
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 00:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBOXne (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 18:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBOXnd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 18:43:33 -0500
Received: from cmx-torrgo001.bell.net (mta-tor-005.bell.net [209.71.212.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A572A6D4;
        Wed, 15 Feb 2023 15:43:31 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63EA076D004E6514
X-CM-Envelope: MS4xfOuxAnjpuxxhlNzVTbfX5mpK1P4gw8jZ6aSwgC6+2Ur7tiRqIKdR6aVNkGfDdVWav3blLeCHun8ar/zi7oAw4Dr3/kpYJFpB85i7331ONtudA17781kk
 8v/JxFhPiOgqUbPcfqTCK9q1aoOkrTNZlLNkyrIeIt1aaRNEy1zVFCXx2244PSv3qnTDB7TGN/p0uuRHOuLnYawrcl9S9CP/tzAwhE0jyGnEPF9JuRnBotNY
 qmPIQ4JUclyDRxM1VU6skoGQ8MihqVYANSUyShxMFjFqP85vXgajM7SgP8tLOpI5vmDGPGO5qITPm6jMCqqk2TR2QeOeRNpt7uJ9N1IT128jVeUGg78BYnIy
 4eoP9swRF3uibADzF80ChYA3WxGo6oDtNvzsDZGKGiUY13no9V8=
X-CM-Analysis: v=2.4 cv=M8Iulw8s c=1 sm=1 tr=0 ts=63ed6e1f
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=WIMuH9iB4f1ny0LeIgcA:9 a=QEXdDO2ut3YA:10
 a=ATlVsGG5QSsA:10 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63EA076D004E6514; Wed, 15 Feb 2023 18:43:27 -0500
Message-ID: <e63a4c98-4f8d-7176-9e63-4edbf3329d7a@bell.net>
Date:   Wed, 15 Feb 2023 18:43:28 -0500
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
 <c7725c80-ba8c-1182-7adc-bc107f4f5b75@bell.net>
 <5e72c1fc-1a7b-a4ed-4097-96816b802e6d@bell.net>
 <c100a264-d897-1b9e-0483-22272bccd802@bell.net>
 <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <73566dc4-317b-5808-a5a5-78dc195ebd77@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-15 6:02 p.m., Jens Axboe wrote:
> and I'm guessing you're running without preempt.
Correct.

-- 
John David Anglin  dave.anglin@bell.net

