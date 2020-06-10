Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A011F4DF9
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 08:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFJGQf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 02:16:35 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48025 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgFJGQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 02:16:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.9JhWL_1591769791;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.9JhWL_1591769791)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Jun 2020 14:16:31 +0800
Subject: Re: [PATCH] io_uring: don't set REQ_F_NOWAIT for regular files opend
 O_NONBLOCK
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1590736708-99812-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <df16e843-6b02-e51f-c99d-9886ead20943@kernel.dk>
 <a35e60c6-4df2-cfd8-e62c-4a1e21c85e22@linux.alibaba.com>
Message-ID: <0711e47d-f0e7-1081-b05a-d517242f7434@linux.alibaba.com>
Date:   Wed, 10 Jun 2020 14:16:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a35e60c6-4df2-cfd8-e62c-4a1e21c85e22@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Could you please spent some time to look at this? 

Thanks,
Jiufei

On 2020/6/1 上午11:26, Jiufei Xue wrote:
> Hi Jens,
> 
> On 2020/5/29 下午10:20, Jens Axboe wrote:
>> On 5/29/20 1:18 AM, Jiufei Xue wrote:
>>> When read from a regular file that was opened O_NONBLOCK, it will
>>> return EAGAIN if the page is not cached, which is not expected and
>>> fails the application.
>>>
>>> Applications written before expect that the open flag O_NONBLOCK has
>>> no effect on a regular file.
>>>
>>> Fix this by not setting REQ_F_NOWAIT for regular files.
>>
>> Agree, this also matches what we do for sockets. You need to update
>> the comment as well, though.
>>
> Reading from an O_NONBLOCK socket will return EAGAIN if there isn't any
> unread data in the buffer which is expected.So I don't know what is your
> meaning about that. Do you mean the recv() interface? 
> 
> Regards,
> Jiufei
> 
