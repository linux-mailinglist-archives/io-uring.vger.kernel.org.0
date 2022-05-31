Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEE25389A1
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 03:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbiEaBcg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 21:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiEaBcf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 21:32:35 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B14059BA7
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 18:32:29 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEt7FV0_1653960740;
Received: from 30.236.22.228(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEt7FV0_1653960740)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 31 May 2022 09:32:21 +0800
Message-ID: <a818d0c3-8f07-5b2a-4bed-b9e546711e15@linux.alibaba.com>
Date:   Tue, 31 May 2022 09:32:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [LIBURING PATCH v2] Let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530173604.38000-1-xiaoguang.wang@linux.alibaba.com>
 <50c38579-c8de-6f23-d24b-1450123a7517@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <50c38579-c8de-6f23-d24b-1450123a7517@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 5/30/22 11:36 AM, Xiaoguang Wang wrote:
>> Allocate available direct descriptors instead of having the
>> application pass free fixed file slots. To use it, pass
>> IORING_FILE_INDEX_ALLOC to io_uring_prep_files_update(), then
>> io_uring in kernel will store picked fixed file slots in fd
>> array and let cqe return the number of slots allocated.
> Thanks, applied and made a few tweaks. Most notably renaming
> the helper to io_uring_prep_close_direct_unregister() which
> is pretty long but more descriptive than _all() which doesn't
> really tell us anything useful I think.
Agree, thanks.

>
> Please check and see if you agree with that, and the man page
> tweak as well.
Yeah, I have checked it, thanks.

Regards,
Xiaoguang Wang

>

