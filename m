Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA836BEDD3
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 17:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCQQPZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 12:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQQPW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 12:15:22 -0400
Received: from cmx-mtlrgo001.bell.net (mta-mtl-001.bell.net [209.71.208.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BA231BD2;
        Fri, 17 Mar 2023 09:15:16 -0700 (PDT)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [209.226.249.40]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63F65B42026D8687
X-CM-Envelope: MS4xfOOxCu+JpTsOeY0x++eWBh/dF5BB539NUG7HNaEptS+e4V9JljLHQ5xgZ9NBTAomQ9elQSBjdolORydwFP8mrePPLaBEKx9qxgWbLQ6JdbQLKy21KRUe
 tC15PVEOeQtpps9t/XxSYzzSe8Z4e/SkgsTwSjc9n8TU3OEnLwWZkt2QsDgolyXneW7zeUCKW9IRS6PCuV9ejSxRvwQwjfwZi0Yr3OiIHEFDPnkfwVilOtBo
 Auz2Qqxt5TN5gyrDdPTk2IfuRLuSIBBly0gDGqLvocBHhJEsZaIfSSxrY8fu26mbmSb23gtGbDTnivK5YB+pTibpo3BrgFmMiyuMSpRv3Q4=
X-CM-Analysis: v=2.4 cv=AuWNYMxP c=1 sm=1 tr=0 ts=6414920d
 a=qOHgmCO8ryfXM3F4aXJsSA==:117 a=qOHgmCO8ryfXM3F4aXJsSA==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=1gPPIBU9JOwuX4kq5LkA:9 a=QEXdDO2ut3YA:10
 a=imerMtPIIHEA:10 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (209.226.249.40) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63F65B42026D8687; Fri, 17 Mar 2023 12:15:09 -0400
Message-ID: <e8c78c0f-b94a-2ac8-b827-e7938182347f@bell.net>
Date:   Fri, 17 Mar 2023 12:15:10 -0400
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
 <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
 <babf3f8e-7945-a455-5835-0343a0012161@bell.net>
 <29ef8d4d-6867-5987-1d2e-dd786d6c9cb7@kernel.dk>
 <42af7eb1-b44d-4836-bf72-a2b377c5cede@kernel.dk>
 <827b725a-c142-03b9-bbb3-f59ed41b3fba@kernel.dk>
 <31e9595d-691b-c87c-e38a-b369143fc946@bell.net>
 <f4da7453-49ef-73fb-7feb-fcca543bd37e@kernel.dk>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <f4da7453-49ef-73fb-7feb-fcca543bd37e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-03-17 11:57 a.m., Jens Axboe wrote:
>> Running test buf-ring.t register buf ring failed -22
>> test_full_page_reg failed
>> Test buf-ring.t failed with ret 1
> The buf-ring failure with the patch from my previous message is because
> it manually tries to set up a ring with an address that won't work. The
> test case itself never uses the ring, it's just a basic
> register/unregister test. So would just need updating if that patch goes
> in to pass on hppa, there's nothing inherently wrong here.
>
I would suggest it.  From page F-7 of the PA-RISC 2.0 Architecture:

    All other uses of non-equivalent aliasing (including simultaneously enabling multiple non-equivalently
    aliased translations where one or more allow for write access) are prohibited, and can cause machine
    checks or silent data corruption, including data corruption of unrelated memory on unrelated pages.

Dave

-- 
John David Anglin  dave.anglin@bell.net

