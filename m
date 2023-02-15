Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E88E69810D
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 17:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBOQjJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 11:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBOQjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 11:39:06 -0500
Received: from cmx-torrgo002.bell.net (mta-tor-001.bell.net [209.71.212.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB0F93F2;
        Wed, 15 Feb 2023 08:38:57 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E4C09200A01652
X-CM-Envelope: MS4xfMXXOonea0nOowVsPp2s8/RuCnajqsfkDyiVd3Zdx0DBhoxsORiwtqj3IjU/TAG24DzoHxsWWx177XX/zeL7UQJzRv/HaPjB1oU5W6+9bePJRDCtt8rG
 YLlPQhjwBFwWU58E0EB3sVXtAC4egKoVIxUEzkXMmpVYSlOBgoOYQYvpICuDAL+0naF5MW8Z4oyGe5AiZyDCjPskigiePCD3SvvKMx9lOJ8bvHvpft/ZFobO
 rMEx7DTXLJRNR5n2XM7+RqGanrRsQT4Na8bHdEW9m5XN/GcoXDPggmxwGp8PRrJeVZw23SSo2lMAJN18DHj7jmEI3YEpdcdMW5YrDJjevllb554bq23xfoF3
 9Yu/O6avUHw6wu7QxH+f0KpKjRlL1KC0xEZ2gek3ZH8g+fTV2wk=
X-CM-Analysis: v=2.4 cv=ULS+oATy c=1 sm=1 tr=0 ts=63ed0a9d
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=xNf9USuDAAAA:8 a=FBHGMhGWAAAA:8 a=lrTyYbZB3KvdHd6MpVcA:9
 a=QEXdDO2ut3YA:10 a=jYJgLHWX644A:10 a=SEwjQc04WA-l_NiBhQ7s:22
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E4C09200A01652; Wed, 15 Feb 2023 11:38:53 -0500
Message-ID: <0bfe6cdb-2749-c08d-a1b2-ef46fed1ded3@bell.net>
Date:   Wed, 15 Feb 2023 11:38:54 -0500
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
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
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

On 2023-02-15 10:56 a.m., Jens Axboe wrote:
>> Is there maybe somewhere a more detailled testcase which I could try too?
> Just git clone liburing:
>
> git clone git://git.kernel.dk/liburing
>
> and run make && make runtests in there, that'll go through the whole
> regression suite.
Here are test results for Debian liburing 2.3-3 (hppa) with Helge's original patch:
https://buildd.debian.org/status/fetch.php?pkg=liburing&arch=hppa&ver=2.3-3&stamp=1676478898&raw=0

-- 
John David Anglin  dave.anglin@bell.net

