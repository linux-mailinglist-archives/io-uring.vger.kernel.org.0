Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E795AA7F7
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiIBGS6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiIBGS5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:18:57 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036BBA9C7
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:18:56 -0700 (PDT)
Received: from [192.168.230.80] (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 1447080C2F;
        Fri,  2 Sep 2022 06:18:51 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662099536;
        bh=0sVz59M/QrE0eV7X9clGEEpsRknZfjIWlrXTNjzrznk=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=iHdrYwBDwGB0XB8SnUj08YMup3O3LUQ7DQ5ltu9yy6Qxms7uXsKEuUNJ9aBMrHO5l
         1z+e21MhbzXUhKz0HOpXbKZrWI/YwqpBuntrGKWguw5aD/E+xFSz8XttlVHqW3My7U
         v0mJGj3VfdVS6GAXLMbxPSogTXd7LKm+xM9a7fMjDurcm1UM+ncboy8Ad+wJYkAWG0
         zuzmW51Xh6RlRAt40TdsKqGqBoUPLK9TxqqPojWOtIQuwuCb7V0Heg0kGOCj07RHgA
         7viHcHzURx8Cc75wMR211OCVTUqe9BIQV3vER2VjMwxGM/KQUoMQDYcUTGq+8jgAHv
         g8ELFL91VpxiQ==
Message-ID: <5104fa92-41a7-86d9-758e-775fcdfc1650@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:18:48 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
References: <20220902011548.2506938-1-ammar.faizi@intel.com>
 <20220902011548.2506938-3-ammar.faizi@intel.com>
 <CAOG64qNCEss+i-MQV4gJjZh4Eun1o0U1E2WcFrgeg1ifjUMo6Q@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RESEND PATCH liburing v1 02/12] t/poll-link: Don't brute force
 the port number
In-Reply-To: <CAOG64qNCEss+i-MQV4gJjZh4Eun1o0U1E2WcFrgeg1ifjUMo6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 1:04 PM, Alviro Iskandar Setiawan wrote:
> On Fri, Sep 2, 2022 at 8:18 AM Ammar Faizi wrote:
>>   static void signal_var(int *var)
>>   {
>>           pthread_mutex_lock(&mutex);
>>           *var = 1;
>> @@ -80,45 +81,37 @@ void *recv_thread(void *arg)
>>          ret = io_uring_queue_init(8, &ring, 0);
>>          assert(ret == 0);
>>
>>          int s0 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
>>          assert(s0 != -1);
>>
>>          int32_t val = 1;
>>          ret = setsockopt(s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
>>          assert(ret != -1);
>>          ret = setsockopt(s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
>>          assert(ret != -1);
>>
>> -       struct sockaddr_in addr;
>> +       struct sockaddr_in addr = { };
> 
> move this variable to the top plz, with that fixed:
> 
> Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Will do that in v2 revision. Thanks!

-- 
Ammar Faizi
