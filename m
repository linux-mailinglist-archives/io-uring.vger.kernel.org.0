Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755D6186E71
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2020 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbgCPPYH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Mar 2020 11:24:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34278 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731483AbgCPPYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Mar 2020 11:24:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so8169686plm.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2020 08:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FiqC1D7/vKdG7V8WKiiX31TIuTEoPFLmE5ohi3P9FBY=;
        b=1ravGhVMKNy1IfqnrWq3NNKbte960yD5I/0syGiJfo6eENyGsJfMglcB5V8t38uEUM
         N0dnhDuuWIcgXouutX89LORmhOaaE32YWOcPPWajwSCAtu79h6+S9yhi392NgtueMGeM
         Uv0Uk0vZ3ytLaahrUc57HfA5SWOQ1spt2HrsgiVXD0VU4+j4vqSjGV3k2S05DFxGv2KC
         5iwKFEBevnJExxj36JcFs12Q1lWgyoGUCOEQaFySEK7tt5TSE8UK/enLmmrvP8rrnnzM
         kjIsyf2n9f3n8YBd7AOTT/ILByOwMkcINWgCLhQ0W0HNIFAMGLgqjQNFr4lN8C7KM1vF
         hgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FiqC1D7/vKdG7V8WKiiX31TIuTEoPFLmE5ohi3P9FBY=;
        b=AEY7LNb+lfiihbMw/wLdOPT5Gfb7ENZpCEzAAEV1YjUm0KLSjHp44P8eesWG9AntPX
         FeTN5jDVKTr5vmMDoOmTKHRToRQrdwEYyMwYhE5N5qgMg2e0QHUR3Af7ZDv2MoYQjNkR
         +wGlhdOXEe4MDKPSAyGMVZRW3wst0j85zQ3mEI/B0Jl5W2sdhk8FWdEA/jH5n5f1maYn
         bxySyBOV7xeIudqMAbGjU6BFi9bSYrIkr7n7hrCH4IxDGBOQqkJBvQg30fXEG56hQKYv
         NHl+B/xXVmRG/J3wyTwUfnkUii0LTByLI3Xn0PTKJNXuVa2a+JFfwfv3VevAMlF9v9wT
         Swpw==
X-Gm-Message-State: ANhLgQ1RIxjWoxn3AmZl+BZl69zSE7yiTRYwkJ8FNG/J/ewFUvmS6ThX
        xBCyevRWWGbKnRO/+Gzw7zx0Bbt7DUG5dA==
X-Google-Smtp-Source: ADFU+vusnkxFdIdQKaudLr+iw2kkv0pjmzkTAC4Spdgsvq9eVdVZkeEzgoTEzA6/lPx4v+eS2feaQA==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr27816347plp.304.1584372244453;
        Mon, 16 Mar 2020 08:24:04 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id l26sm266614pff.136.2020.03.16.08.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 08:24:03 -0700 (PDT)
Subject: Re: bug report about patch "io_uring: avoid ring quiesce for fixed
 file set unregister and update"
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph qi <joseph.qi@linux.alibaba.com>
References: <2b1834e3-1870-66a4-bbf4-70ab8a5109a6@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c5ef8351-359e-2730-7bd6-5a3be3f23f94@kernel.dk>
Date:   Mon, 16 Mar 2020 09:24:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2b1834e3-1870-66a4-bbf4-70ab8a5109a6@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/20 6:14 AM, Xiaoguang Wang wrote:
> hi,
> 
> While diving into iouring file register/unregister/update codes, seems that
> there is one bug in __io_sqe_files_update():
>      if (ref_switch)
>          percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
> 
> The initial fixed_file_data's refs is 1, assume there are no requests
> to get/put this refs, and we firstly register 10 files and later update
> these 10 files, and no memory allocations fails, then above two line of
> codes in __io_sqe_files_update() will be called, before entering
> percpu_ref_switch_to_atomic(), the count of refs is still one, and
> |--> percpu_ref_switch_to_atomic
> |----> __percpu_ref_switch_mode
> |------> __percpu_ref_switch_to_atomic
> |-------- > percpu_ref_get(ref), # now the count of refs will be 2.
> 
> a while later
> |--> percpu_ref_switch_to_atomic_rcu
> |----> percpu_ref_call_confirm_rcu
> |------ > confirm_switch(), # calls io_atomic_switch, note that the count of refs is 2.
> |------ > percpu_ref_put # drop one ref
> 
> static void io_atomic_switch(struct percpu_ref *ref)
> {
> 	struct fixed_file_data *data;
> 
> 	/*
> 	 * Juggle reference to ensure we hit zero, if needed, so we can
> 	 * switch back to percpu mode
> 	 */
> 	data = container_of(ref, struct fixed_file_data, refs);
> 	percpu_ref_put(&data->refs);
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> After this operation, the count of refs is 1 now, still not zero, so
> io_file_data_ref_zero won't be called, then io_ring_file_ref_flush()
> won't be called, this fixed_file_data's refs will always be in atomic mode,
> which is bad.
> 
> 	percpu_ref_get(&data->refs);
> }
> 
> To confirm this bug, I did a hack to kernel:
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5812,7 +5812,10 @@ static bool io_queue_file_removal(struct fixed_file_data *data,
>           * If we fail allocating the struct we need for doing async reomval
>           * of this file, just punt to sync and wait for it.
>           */
> +       /*
>          pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
> +       */
> +       pfile = NULL;
>          if (!pfile) {
>                  pfile = &pfile_stack;
>                  pfile->done = &done;
> To simulate memory allocation failures, then run liburing/test/file-update,
> 
> [lege@localhost test]$ sudo cat /proc/2091/stack
> [sudo] password for lege:
> [<0>] __io_sqe_files_update.isra.85+0x175/0x330
> [<0>] __io_uring_register+0x178/0xe20
> [<0>] __x64_sys_io_uring_register+0xa0/0x160
> [<0>] do_syscall_64+0x55/0x1b0
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> (gdb) list * __io_sqe_files_update+0x175
> 0xffffffff812ec255 is in __io_sqe_files_update (fs/io_uring.c:5830).
> 5825            llist_add(&pfile->llist, &data->put_llist);
> 5826
> 5827            if (pfile == &pfile_stack) {
> 5828                    percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
> 5829                    wait_for_completion(&done);
> 5830                    flush_work(&data->ref_work);
> 5831                    return false;
> 
> file-update will always hang in wait_for_completion(&done), it's because
> io_ring_file_ref_flush never has a chance to run.
> 
> I think how to fix this issue a while, doesn't find a elegant method yet.
> And applications may issue requests continuously, then fixed_file_data's refs
> may never have a chance to reach zero, refs will always be in atomic mode.
> Or the simplest method is to use percpu_ref per registered file :)

For the "oh crap I can't allocate data" stack path, I think the below
should fix it. Might not be a bad idea to re-think the live updates in
general, though.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index b1fbc4424aa6..3f0c8291a17c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5612,10 +5612,12 @@ static void io_ring_file_ref_flush(struct fixed_file_data *data)
 	while ((node = llist_del_all(&data->put_llist)) != NULL) {
 		llist_for_each_entry_safe(pfile, tmp, node, llist) {
 			io_ring_file_put(data->ctx, pfile->file);
-			if (pfile->done)
+			if (pfile->done) {
+				percpu_ref_get(&data->refs);
 				complete(pfile->done);
-			else
+			} else {
 				kfree(pfile);
+			}
 		}
 	}
 }
@@ -5830,6 +5836,7 @@ static bool io_queue_file_removal(struct fixed_file_data *data,
 	llist_add(&pfile->llist, &data->put_llist);
 
 	if (pfile == &pfile_stack) {
+		percpu_ref_put(&data->refs);
 		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
 		wait_for_completion(&done);
 		flush_work(&data->ref_work);

-- 
Jens Axboe

