Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B101A43CD31
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 17:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhJ0PO3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 11:14:29 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:33851 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242679AbhJ0POY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 11:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635347519; x=1666883519;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=FL3rJ10DyM5Xsz0RCdyIcnAq1FcXhtCApK8hfIMFYLY=;
  b=RA+tGnRnjOnaYtv64pXB6mGlj6dplla/NLkeOjlLuVSIxBRYSVR6M50T
   H/t8i4QThBQOJK4pdTOVPt4I+wd/z5BCl6YD9RekoYxCgjO6yruPTiDqR
   ELUYhqVWNvfr9dSywiqXXwGHmyg/VOnyeIUBOLZ90t/9xUZjIYBY0G5bd
   Q=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 27 Oct 2021 08:11:59 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 08:11:58 -0700
Received: from [10.110.114.196] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 27 Oct 2021
 08:11:58 -0700
Subject: Re: [PATCH] io_uring: fix a GCC warning in wq_list_for_each()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211025145906.71955-1-quic_qiancai@quicinc.com>
 <27d0d7bd-a5c3-27ca-03b3-ea3c5c363380@gmail.com>
From:   Qian Cai <quic_qiancai@quicinc.com>
Message-ID: <5b088800-d552-68a1-bf66-6023ccad0ca8@quicinc.com>
Date:   Wed, 27 Oct 2021 11:11:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <27d0d7bd-a5c3-27ca-03b3-ea3c5c363380@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 10/27/21 5:56 AM, Pavel Begunkov wrote:
> On 10/25/21 15:59, Qian Cai wrote:
>> fs/io_uring.c: In function '__io_submit_flush_completions':
>> fs/io_uring.c:2367:33: warning: variable 'prev' set but not used
>> [-Wunused-but-set-variable]
>>   2367 |  struct io_wq_work_node *node, *prev;
>>        |                                 ^~~~
>>
>> Fixed it by open-coded the wq_list_for_each() without an unused previous
>> node pointer.
> 
> That's intentional, the var is optimised out and it's better to
> not hand code it (if possible).

Yes, this is pretty minor. Not going to insist if people don't like for
some reasons.
