Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF3723C2E4
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 03:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgHEBJ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 21:09:26 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:34091 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgHEBJZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 21:09:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U4mv1Nm_1596589762;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4mv1Nm_1596589762)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Aug 2020 09:09:22 +0800
Subject: Re: [PATCH liburing v2 1/2] io_uring_enter: add timeout support
To:     Stefan Metzmacher <metze@samba.org>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1596532913-70757-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596532913-70757-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <a1c1413b-ede9-acf5-7bfb-7b617897f1d7@samba.org>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <1072d796-5347-eb4b-b0ad-1e1838c1a100@linux.alibaba.com>
Date:   Wed, 5 Aug 2020 09:08:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a1c1413b-ede9-acf5-7bfb-7b617897f1d7@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2020/8/4 下午6:25, Stefan Metzmacher wrote:
> Am 04.08.20 um 11:21 schrieb Jiufei Xue:
>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>> supported. Applications should use io_uring_set_cqwait_timeout()
>> explicitly to asked for the new feature.
>>
>> In addition in this commit we add two new members to io_uring and a pad
>> for future flexibility. So for the next release, applications have to
>> re-compile against the lib.
> 
> I don't think this is an option, existing applications need to work.
> 
> Or they must fail at startup when the runtime dependencies are resolved.
> Which means the soname of the library has to change.
>

Yes, I think the version should bump to 2.0.X with next release.

Jens, 
should I bump the version with this patch set? Or you will bump it
before next release.

Thanks,
Jiufei

> metze
> 
