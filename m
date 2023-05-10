Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3A96FD43A
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 05:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbjEJDWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 23:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbjEJDWB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 23:22:01 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C672B3C27;
        Tue,  9 May 2023 20:20:53 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QGKzh2xb6z4f3jMc;
        Wed, 10 May 2023 11:20:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgBH9CGODVtkcqmYIQ--.28977S3;
        Wed, 10 May 2023 11:20:48 +0800 (CST)
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
To:     Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai1@huaweicloud.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
 <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
 <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
 <1155743b-2073-b778-1ec5-906300e0570a@kernel.dk>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7def2fca-c854-f88e-3a77-98a999f7b120@huaweicloud.com>
Date:   Wed, 10 May 2023 11:20:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1155743b-2073-b778-1ec5-906300e0570a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgBH9CGODVtkcqmYIQ--.28977S3
X-Coremail-Antispam: 1UD129KBjvJXoWrury8WFWDGr4UWr48tryrWFg_yoW8Jryxpr
        Z29a9xKrs5Jr18tw18Kw1UZw1FvrZ8uF1agr1UJ34UZr95trnFv3s3XanF9rZrKw40kF4j
        kw45tFZ3t34kA3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Jens

在 2023/05/10 10:17, Jens Axboe 写道:
> On 5/9/23 8:00?PM, Yu Kuai wrote:
>> Hi,
>>
>> ? 2023/05/10 9:49, Yu Kuai ??:
>>> Hi,
>>>
>>> ? 2023/05/10 9:29, Yu Kuai ??:
>>>> Hi,
>>>>
>>>> ? 2023/05/10 8:49, Guangwu Zhang ??:
>>>>> Hi,
>>>>>
>>>>> We found this kernel NULL pointer issue with latest
>>>>> linux-block/for-next, please check it.
>>>>>
>>>>> Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>>>>>
>>>>>
>>>>> [  112.483804] BUG: kernel NULL pointer dereference, address: 0000000000000048
>>>
>>> Base on this offset, 0x48 match bio->bi_blkg, so I guess this is because
>>> bio is NULL, so the problem is that passthrough request insert into
>>> elevator.
>>>
>> Sorry that attached patch has some problem, please try this one.
> 
> Let's please fix this in bfq, this isn't a core issue and it's not a
> good idea to work around it there.
> 

I can do that, but I'm not sure because it seems passthrough rq is not
supposed to insert into elevator.

Bfq always expect that bio is not NULL, and before this commit
a327c341dc65 ("blk-mq: fix passthrough plugging"), passthrough rq can
never insert into plug, and therefor passthrough rq can never insert
into elevator.

Thanks,
Kuai


