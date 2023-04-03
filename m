Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2A6D3F2B
	for <lists+io-uring@lfdr.de>; Mon,  3 Apr 2023 10:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbjDCIim (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Apr 2023 04:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjDCIii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Apr 2023 04:38:38 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C527A98;
        Mon,  3 Apr 2023 01:38:35 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VfFpU8U_1680511110;
Received: from 30.97.57.8(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VfFpU8U_1680511110)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 16:38:31 +0800
Message-ID: <1d74e886-89af-bbbb-9bae-37d20ce07fb2@linux.alibaba.com>
Date:   Mon, 3 Apr 2023 16:38:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH V5 16/16] block: ublk_drv: apply io_uring FUSED_CMD for
 supporting zero copy
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dan Williams <dan.j.williams@intel.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
 <20230328150958.1253547-17-ming.lei@redhat.com>
 <2e3c20e0-a0be-eaf3-b288-c3c8fa31d1fa@linux.alibaba.com>
 <ZCP+L0ADCxHo5vSg@ovpn-8-26.pek2.redhat.com>
 <08b047a8-c577-a717-81a8-db8fca8ebab6@linux.alibaba.com>
 <ZCQYVhStekJXpvK1@ovpn-8-26.pek2.redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <ZCQYVhStekJXpvK1@ovpn-8-26.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/29 18:52, Ming Lei wrote:
> On Wed, Mar 29, 2023 at 06:01:16PM +0800, Ziyang Zhang wrote:
>> On 2023/3/29 17:00, Ming Lei wrote:
>>> On Wed, Mar 29, 2023 at 10:57:53AM +0800, Ziyang Zhang wrote:
>>>> On 2023/3/28 23:09, Ming Lei wrote:
>>>>> Apply io_uring fused command for supporting zero copy:
>>>>>
>>>>
>>>> [...]
>>>>
>>>>>  
>>>>> @@ -1374,7 +1533,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>>>>>  	if (!ubq || ub_cmd->q_id != ubq->q_id)
>>>>>  		goto out;
>>>>>  
>>>>> -	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
>>>>> +	/*
>>>>> +	 * The fused command reads the io buffer data structure only, so it
>>>>> +	 * is fine to be issued from other context.
>>>>> +	 */
>>>>> +	if ((ubq->ubq_daemon && ubq->ubq_daemon != current) &&
>>>>> +			(cmd_op != UBLK_IO_FUSED_SUBMIT_IO))
>>>>>  		goto out;
>>>>>  
>>>>
>>>> Hi Ming,
>>>>
>>>> What is your use case that fused io_uring cmd is issued from another thread?
>>>> I think it is good practice to operate one io_uring instance in one thread
>>>> only.
>>>
>>> So far we limit io command has to be issued from the queue context,
>>> which is still not friendly from userspace viewpoint, the reason is
>>> that we can't get io_uring exit notification and ublk's use case is
>>> very special since the queued io command may not be completed forever,
>>
>> OK, so UBLK_IO_FUSED_SUBMIT_IO is guaranteed to be completed because it is
>> not queued. FETCH_REQ and COMMIT_AMD_FETCH are queued io commands and could
>> not be completed forever so they have to be issued from ubq_daemon. Right?
> 
> Yeah, any io command should be issued from ubq daemon context.
> 
>>
>> BTW, maybe NEED_GET_DATA can be issued from other context...
> 
> So far it won't be supported.
> 
> As I mentioned in the link, if io_uring can provide io_uring exit
> callback, we may relax this limit.
> 

Hi, Ming

Sorry, I do not understand... I think UBLK_IO_NEED_GET_DATA is normal IO just like
UBLK_IO_FUSED_SUBMIT_IO. It is issued from one pthread(ubq_daemon for now) and
is completed just in time(not queued). So I think we can allow UBLK_IO_NEED_GET_DATA
to be issued from other context.
