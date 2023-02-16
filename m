Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7169A25B
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 00:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjBPX1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 18:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjBPX1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 18:27:37 -0500
Received: from cmx-mtlrgo002.bell.net (mta-mtl-002.bell.net [209.71.208.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6794F442FB;
        Thu, 16 Feb 2023 15:27:01 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35FA800E27984
X-CM-Envelope: MS4xfEGcSmsPWjYj3DiQ7wLctWxEFfn8EuUVC/2L3fgslKmf3vlq81Ppfrnv3lA7j7tybSbtyCxUsqCqXFRlyp28L4lak8b42px98T/WYmYbUgHQ4l6yrZMN
 CVsD6HOy4Kidors7idsuiV5WEtsoSNjXqMhuDL6PcTnJCikcPnnV0TV/ARX+8T7J4X5WWab5HLq3x543dd8ahgf5UqQ096GngcnJ3w+6u6klQfsckQ3lO1GR
 ypuJIGxxILDjy7bGRIyltkqXGLvQJgmnMJ6e9CaPrfkxJq9Qoj/24qxkgxJ9T/7W+qzRrl0TRKcK19fE7dVANLAn7h9st/Y/FkhGlmQPJDo=
X-CM-Analysis: v=2.4 cv=GcB0ISbL c=1 sm=1 tr=0 ts=63eebbb6
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=rN6HpA5cvidPB5kG5SoA:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35FA800E27984; Thu, 16 Feb 2023 18:26:46 -0500
Message-ID: <b0ad2098-979e-f256-a553-401bad9921e0@bell.net>
Date:   Thu, 16 Feb 2023 18:26:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: liburing test results on hppa
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        linux-parisc <linux-parisc@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, Helge Deller <deller@gmx.de>
References: <64ff4872-cc6f-1e6a-46e5-573c7e64e4c9@bell.net>
 <c198a68c-c80e-e554-c33e-f4448e89764a@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <c198a68c-c80e-e554-c33e-f4448e89764a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-16 6:12 p.m., Jens Axboe wrote:
> On 2/16/23 4:00?PM, John David Anglin wrote:
>> Running test buf-ring.t bad run 0/0 = -233
>> test_running(1) failed
>> Test buf-ring.t failed with ret 1
> As mentioned previously, this one and the other -233 I suspect are due
> to the same coloring issue as was fixed by Helge's patch for the ring
> mmaps, as the provided buffer rings work kinda the same way. The
> application allocates some aligned memory, and registers it and the
> kernel then maps it.
>
> I wonder if these would work properly if the address was aligned to
> 0x400000? Should be easy to verify, just modify the alignment for the
> posix_memalign() calls in test/buf-ring.c.
Doesn't help.  Same error.  Can you point to where the kernel maps it?

-- 
John David Anglin  dave.anglin@bell.net

