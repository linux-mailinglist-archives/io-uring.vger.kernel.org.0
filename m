Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A53520440
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 20:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiEISPa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 14:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240034AbiEISP3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 14:15:29 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A661DA74;
        Mon,  9 May 2022 11:11:34 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 25CCB1F43FBD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652119882;
        bh=MbPPprIzKvxmhduX4Hn0tkmwmTra/9U7Mk0pwr6WmI8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HyIWaVM8jvUSedn2yuZZVY27tqvcE3NVSCaa1N2QDtZFqmI9ptONPMvD3kbpJ/TP6
         6kv/sRrcWZcdgOPl7YeYdbQ0XZTAyfXswqhh1QF1tIbhfSvdw8jCB1hiQqLr301gf2
         mP280UWL5V24h/FLNb3ahwsTE4OfxVwAN28qOySm18x3IMOqGr2IWDKUR9h+LsDPw0
         pK6AgaTe4JzUxf4Chu90loNUrkWjeWEquvsurdO7wdBHCiOQe5nnH02ylm0BFyXygQ
         7qQVjoWK7znnY8z3Upwj8Pfl30U9voKmuEEm/OsR5+feSGFIyyDT5qeDjl7SAoHzHP
         vieHl9nu9681w==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Organization: Collabora
References: <20220509092312.254354-1-ming.lei@redhat.com>
        <8e3ecd00-1c73-7481-fec2-158528b2798f@infradead.org>
Date:   Mon, 09 May 2022 14:11:19 -0400
In-Reply-To: <8e3ecd00-1c73-7481-fec2-158528b2798f@infradead.org> (Randy
        Dunlap's message of "Mon, 9 May 2022 09:00:37 -0700")
Message-ID: <87bkw6lgoo.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> On 5/9/22 02:23, Ming Lei wrote:
>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>> index fdb81f2794cd..3893ccd82e8a 100644
>> --- a/drivers/block/Kconfig
>> +++ b/drivers/block/Kconfig
>> @@ -408,6 +408,13 @@ config BLK_DEV_RBD
>>  
>>  	  If unsure, say N.
>>  
>> +config BLK_DEV_USER_BLK_DRV
>> +	bool "Userspace block driver"
>> +	select IO_URING
>> +	default y
>
> Any "default y" driver is highly questionable and needs to be justified.
>
> Also: why is it bool instead of tristate?

I think it's only bool because it depends on task_work_add, which is not exported to
modules.  It is something to be fixed for sure, can that function just be exported?

-- 
Gabriel Krisman Bertazi
