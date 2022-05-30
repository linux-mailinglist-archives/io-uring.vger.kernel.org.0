Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476935385F1
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 18:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiE3QPZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 12:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiE3QPY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 12:15:24 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512C16C55F
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 09:15:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEqjnoM_1653927319;
Received: from 192.168.0.103(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEqjnoM_1653927319)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 31 May 2022 00:15:20 +0800
Message-ID: <ea209f4d-cbf6-cc9f-ccab-9c28e9b58a35@linux.alibaba.com>
Date:   Tue, 31 May 2022 00:15:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v2] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530131520.47712-1-xiaoguang.wang@linux.alibaba.com>
 <3064f1e4-c66b-a90b-8073-dc63525c5aca@kernel.dk>
 <08f2395c-50b2-850a-0ce9-583be34017e3@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <08f2395c-50b2-850a-0ce9-583be34017e3@kernel.dk>
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

> On 5/30/22 7:18 AM, Jens Axboe wrote:
>> On 5/30/22 7:15 AM, Xiaoguang Wang wrote:
>>> @@ -5945,16 +5948,22 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>>>  	return 0;
>>>  }
>>>  
>>> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
>>> +
>> This should go into uapi/linux/io_uring.h - I'll just move it, no need
>> for a v3 for that. Test case should add it too.
> Here's what I merged so far:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=f6b0e7c95c20d4889b811ada7fc0061e8cb4e82e
>
> Changes:
>
> - I re-wrote the commit message slightly
> - Move flag to header where it belongs
> - Get rid of 'goto' in io_files_update_with_index_alloc()
> - Drop unneeded variable in io_files_update_with_index_alloc()
I think file registration feature is much easier to use now, thanks!

Regards,
Xiaoguang Wang

>

