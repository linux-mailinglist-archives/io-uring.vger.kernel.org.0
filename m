Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE4E6FD780
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbjEJGzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 02:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbjEJGzo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 02:55:44 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CA7421D;
        Tue,  9 May 2023 23:55:20 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QGQl66f37z4f3nqg;
        Wed, 10 May 2023 14:55:14 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgAXvuvTP1tkaIIlJA--.17779S3;
        Wed, 10 May 2023 14:55:16 +0800 (CST)
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address:
 0000000000000048
To:     Ming Lei <ming.lei@redhat.com>, Guangwu Zhang <guazhang@redhat.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAGS2=YosaYaUTEMU3uaf+y=8MqSrhL7sYsJn8EwbaM=76p_4Qg@mail.gmail.com>
 <ecb54b0d-a90e-a2c9-dfe5-f5cec70be928@huaweicloud.com>
 <cde5d326-4dcb-5b9c-9d58-fb1ef4b7f7a8@huaweicloud.com>
 <007af59f-4f4c-f779-a1b6-aaa81ff640b3@huaweicloud.com>
 <1155743b-2073-b778-1ec5-906300e0570a@kernel.dk>
 <7def2fca-c854-f88e-3a77-98a999f7b120@huaweicloud.com>
 <CAGS2=YocNy9PkgRzzRdHAK1gGdjMxzA--PYS=sPrX_nCe4U6QA@mail.gmail.com>
 <ZFs8G9RmHLYZ2Q0N@fedora>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <109a1c64-ab81-b719-6913-600d78e3f10c@huaweicloud.com>
Date:   Wed, 10 May 2023 14:55:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ZFs8G9RmHLYZ2Q0N@fedora>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgAXvuvTP1tkaIIlJA--.17779S3
X-Coremail-Antispam: 1UD129KBjvdXoW7XF1UZFyfur1fZF4UGr4kZwb_yoWfAFc_Ww
        4vvasrGFn8XFs0kF4qkFy3Zr9akr1DXry8ur9rXF42gFWxJ3ZrZws8uw1UZwsxGa4xG3Wf
        Gryqv348tr1aqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

ÔÚ 2023/05/10 14:39, Ming Lei Ð´µÀ:
> On Wed, May 10, 2023 at 12:05:07PM +0800, Guangwu Zhang wrote:
>> HI,
>> after apply your patch[1], the system will panic after reboot.

This is werid, I just reporduce this problem in my VM, and I verified
this patch can fix the problem.

Anyway, Ming's patch looks better, you can try it.

Thanks,
Kuai
>>
> 
> Maybe you can try the following patch?
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f6dad0886a2f..d84174a7e997 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1303,7 +1303,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
>           * device, directly accessing the plug instead of using blk_mq_plug()
>           * should not have any consequences.
>           */
> -       if (current->plug && !at_head) {
> +       if (current->plug && !at_head && rq->bio) {
>                  blk_add_rq_to_plug(current->plug, rq);
>                  return;
>          }
> 
> 
> thanks,
> Ming
> 
> .
> 

