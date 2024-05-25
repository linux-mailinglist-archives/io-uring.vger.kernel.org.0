Return-Path: <io-uring+bounces-1963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E98B18CEE21
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 09:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 221E21C20BD1
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 07:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACBAA93C;
	Sat, 25 May 2024 07:19:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F588BE4B;
	Sat, 25 May 2024 07:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716621589; cv=none; b=mc4ybfVcDX/b7RghOyxwwqwQwMz6q8Xy/YcfyfYXCp2LxbSeenzqDWGbtqYO9lY163Gu8RYQMU8P4VYwlknaVshPIvXHdXdroOLlZGePQ+Izkx2MyeyQelqXEPGnDwqeS1uHrE61fPd0WhCk40XJJlaraWk7Nz154CGX7eQ/peY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716621589; c=relaxed/simple;
	bh=CTdedY+T4JhD8LfJ6OWl9f//J0RVuh/3fU0nBq+skOo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=rzBGJ4DrAjuYSXwPdhcTXC9h1bD5yt0Fa+vqGB8otAS6Y/reLSukhyd2HiPDreajsFgPj0BcHPyWYXrSHNUvwhbpjAYqK01TTEK+fc3BXJfX3aaDeLBRpmEXjqR9r/Qz1I1fn+ZvuU28ry6RyWciYhrBG3qqYmlH468LabgXKwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VmYFN5dlPz4f3jZ6;
	Sat, 25 May 2024 15:19:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A9B141A0181;
	Sat, 25 May 2024 15:19:42 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP2 (Coremail) with SMTP id Syh0CgAXPA8KkVFmxtTUNw--.12309S3;
	Sat, 25 May 2024 15:19:42 +0800 (CST)
Message-ID: <9bb4beb1-06d4-2127-31aa-003c555653d4@huaweicloud.com>
Date: Sat, 25 May 2024 15:19:38 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [bug report] WARNING: CPU: 2 PID: 3445306 at
 drivers/block/ublk_drv.c:2633 ublk_ctrl_start_recovery.constprop.0+0x74/0x180
From: Li Nan <linan666@huaweicloud.com>
To: Changhui Zhong <czhong@redhat.com>,
 Linux Block Devices <linux-block@vger.kernel.org>, io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>, "houtao1@huawei.com"
 <houtao1@huawei.com>, "yi.zhang@huawei.com" <yi.zhang@huawei.com>
References: <CAGVVp+UvLiS+bhNXV-h2icwX1dyybbYHeQUuH7RYqUvMQf6N3w@mail.gmail.com>
 <4b9986cf-003b-0ad2-75be-5745e979d36d@huaweicloud.com>
In-Reply-To: <4b9986cf-003b-0ad2-75be-5745e979d36d@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAXPA8KkVFmxtTUNw--.12309S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyUKFykWFykJFyrAr1rCrg_yoWfAwc_uF
	1vyr9rJwsrCF1Fkw42k3W3JrWq9F4jqryxWFWavFZIvry7XFnrX3srZ3srCa1kGayrAFn8
	Ar1Dtw48Jr1rGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
	x4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14
	v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE
	67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1VOJ7
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2024/5/24 17:45, Li Nan 写道:
> 
> 
> 在 2024/5/24 11:49, Changhui Zhong 写道:
>> Hello,
>>
>> I hit the kernel panic when running test ubdsrv  generic/005，
>> please help check it and let me know if you need any info/testing for
>> it, thanks.
>>

Can you test the following patch? WARN will still be triggered, but the
NULL pointer dereference will be fixed.

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 4e159948c912..99b621b2d40f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2630,7 +2630,8 @@ static void ublk_queue_reinit(struct ublk_device *ub, 
struct ublk_queue *ubq)
  {
  	int i;

-	WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq)));
+	if (WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq))))
+		return;

  	/* All old ioucmds have to be completed */
  	ubq->nr_io_ready = 0;

-- 
Thanks,
Nan


