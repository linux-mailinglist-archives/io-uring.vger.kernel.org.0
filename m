Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD491F5F84
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 03:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFKBgx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 21:36:53 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:43104 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgFKBgx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 21:36:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.DrSF7_1591839396;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.DrSF7_1591839396)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Jun 2020 09:36:50 +0800
Subject: Re: [PATCH] io_uring: add EPOLLEXCLUSIVE flag to aoid thundering herd
 type behavior
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591769708-55768-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <fba0cf9c-1d9a-52d9-29d9-fce01b0a8a06@kernel.dk>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <84caca8b-1e34-cc70-c395-c826b7415f35@linux.alibaba.com>
Date:   Thu, 11 Jun 2020 09:36:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fba0cf9c-1d9a-52d9-29d9-fce01b0a8a06@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2020/6/11 上午8:01, Jens Axboe wrote:
> On 6/10/20 12:15 AM, Jiufei Xue wrote:
>> Applications can use this flag to avoid accept thundering herd.
> 
> So with this, any IORING_OP_POLL_ADD will be exclusive. Seems to me
> that the other poll path we have could use it too by default, and
> at that point, we could clean this up (and improve) it further by
> including that?
> 
Sorry, I have sent the wrong patch. I think the flag should be determined by
user, I will send the new version soon.

Thanks,
JIufei.
