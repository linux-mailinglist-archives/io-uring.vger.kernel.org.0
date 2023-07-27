Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA75765356
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 14:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjG0MLB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 08:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjG0MK6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 08:10:58 -0400
Received: from out-78.mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E9730C5
        for <io-uring@vger.kernel.org>; Thu, 27 Jul 2023 05:10:56 -0700 (PDT)
Message-ID: <304a5afb-e962-5f60-76a3-f3d079403196@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690459854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clY2DTVayhXqVADxhzKRwCzc3igKW/rfMyB/3mrQaIk=;
        b=Jh8EACm9tjMTMGn8W0LOXDpWwUM8hAukxZOUc+ZujHljEIAJEXfK/Q27dU82+2AwfxMQ+u
        6CCEzchZIoNM3kyVEgWSO/unDHTNx8F6N32NlSpFEEIYUGY32Y4sZX9tqgISt3KCdEmvxr
        EtTbHQ0h21kxAV4ugyGONOCqRnk3oWA=
Date:   Thu, 27 Jul 2023 20:10:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/7] iomap: merge iomap_seek_hole() and iomap_seek_data()
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-2-hao.xu@linux.dev>
 <ZMGVM/BdgsjMSsIF@dread.disaster.area>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZMGVM/BdgsjMSsIF@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/23 05:50, Dave Chinner wrote:
> On Wed, Jul 26, 2023 at 06:25:57PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> The two functions share almost same code, merge them together.
>> No functional change in this patch.
> 
> No, please don't. seek data and seek hole have subtly different
> semantics and return values, and we've explicitly kept them separate
> because it's much easier to maintain them as separate functions with
> separate semantics than combine them into a single function with
> lots of non-obvious conditional behaviour.
> 
> The fact that the new iomap_seek() API requires a boolean "SEEK_DATA
> or SEEK_HOLE" field to indicate that the caller wants makes it clear
> that this isn't actually an improvement over explicit
> iomap_seek_data() and iomap_seek_hole() API calls.
> 
> -Dave.

I'll revert it back in next version. Thanks.
