Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5561524AE
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 03:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgBECGt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 21:06:49 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40008 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbgBECGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 21:06:49 -0500
Received: by mail-pj1-f67.google.com with SMTP id 12so261121pjb.5
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2020 18:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0jBRUb1ZBEx+1dFbOp0wECOIQmaO4/JQGToETxiEsqE=;
        b=N6fkzS5wV+MydCl1UTfzMK4gSRyHh6CBDX0eovaYtuOuLZHpZ0srCuNMTymVgDzfN1
         WGO+jo4i5pFHfarZb/ZWhud4GWK2W/i7q80lrc/+pC0lgE8mJrTIbjc1S4zdY4yLdOZ4
         kIvSpIqozmRIQt0OF+eRtej8vE1diN88V6pwdKB3tIEz7b8S+xJVx6kjxEX78kP6vIOv
         mkfLbmbqCshiZEwihxukArqZdY+UtfTaz1YfLxpRimPkBTWD2k+XzoI+0YVnOztTXA1J
         QmUfLqbtIqwIDP9XGT05hh7fmYI+sz0q6lcqIygJ8rPGhkN+TeEhDBYdaiNNvpBhQkXX
         3IJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0jBRUb1ZBEx+1dFbOp0wECOIQmaO4/JQGToETxiEsqE=;
        b=iTbcjgunRMaXjCo1KzDgxULVbvM2Bd92JdgDYBxQQS9S/CEOF8j3BdOUzHBjPob4C2
         peOPZ4pOma7FR62jLVwEuqOIlqBEwN7RgoiTw3uqobaXANUhwoIEzCcNCBiVH7S3d4Wc
         ARHhfWg9PTywWK71t2rOgmqu6K6y6QKQ1K9Z8tPHAMXBlpC8+ptuItXmB8/hIm3u4bXH
         ngRUV9xUnyBcDhlerSxjs1HwCTKEWV+41GbXYdR85VZKxUoKGb55XLkXb1DpAWsW1PS5
         G2I+E1ULFFa1lHz+kNYMBDtEYLvU3TFVHayL7E1rM5iY2TiJuG+1YVrZ15I43LIccDwf
         LUEQ==
X-Gm-Message-State: APjAAAWbU2ZHIUcfjpM02hZbRWivPiGjerWt5CmR0e5FG9vcyEvwAEpt
        QXosD464igyKOdlXKVgnk5PecQ==
X-Google-Smtp-Source: APXvYqzzFBo3OXX/aDPaDPo3+5xyek1CUtfyZuVwB6bLorUVBuNVRzKOLuw8Rm2fkjXOlkKVySbKEA==
X-Received: by 2002:a17:902:fe0d:: with SMTP id g13mr32241136plj.124.1580868408572;
        Tue, 04 Feb 2020 18:06:48 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o10sm25022074pgq.68.2020.02.04.18.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 18:06:47 -0800 (PST)
Subject: Re: KASAN: use-after-free Write in percpu_ref_switch_to_percpu
To:     syzbot <syzbot+7caeaea49c2c8a591e3d@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000e43122059dc66882@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <523df4b5-03b7-570c-d542-17ed1b9883ba@kernel.dk>
Date:   Tue, 4 Feb 2020 19:06:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <000000000000e43122059dc66882@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/20 2:06 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    754beeec Merge tag 'char-misc-5.6-rc1-2' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15fe4511e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=99db4e42d047be3
> dashboard link: https://syzkaller.appspot.com/bug?extid=7caeaea49c2c8a591e3d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.

I can't reproduce this one, but I think we've seen it internally
as well. Testing the below fix.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87f8655656b5..f204593b4f1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -753,6 +753,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
+static void io_ring_file_ref_flush(struct fixed_file_data *data);
 
 static struct kmem_cache *req_cachep;
 
@@ -5261,15 +5262,10 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
-	/* protect against inflight atomic switch, which drops the ref */
-	percpu_ref_get(&data->refs);
-	/* wait for existing switches */
-	flush_work(&data->ref_work);
 	percpu_ref_kill_and_confirm(&data->refs, io_file_ref_kill);
-	wait_for_completion(&data->done);
-	percpu_ref_put(&data->refs);
-	/* flush potential new switch */
 	flush_work(&data->ref_work);
+	io_ring_file_ref_flush(data);
+	wait_for_completion(&data->done);
 	percpu_ref_exit(&data->refs);
 
 	__io_sqe_files_unregister(ctx);
@@ -5507,14 +5503,11 @@ struct io_file_put {
 	struct completion *done;
 };
 
-static void io_ring_file_ref_switch(struct work_struct *work)
+static void io_ring_file_ref_flush(struct fixed_file_data *data)
 {
 	struct io_file_put *pfile, *tmp;
-	struct fixed_file_data *data;
 	struct llist_node *node;
 
-	data = container_of(work, struct fixed_file_data, ref_work);
-
 	while ((node = llist_del_all(&data->put_llist)) != NULL) {
 		llist_for_each_entry_safe(pfile, tmp, node, llist) {
 			io_ring_file_put(data->ctx, pfile->file);
@@ -5524,7 +5517,14 @@ static void io_ring_file_ref_switch(struct work_struct *work)
 				kfree(pfile);
 		}
 	}
+}
 
+static void io_ring_file_ref_switch(struct work_struct *work)
+{
+	struct fixed_file_data *data;
+
+	data = container_of(work, struct fixed_file_data, ref_work);
+	io_ring_file_ref_flush(data);
 	percpu_ref_get(&data->refs);
 	percpu_ref_switch_to_percpu(&data->refs);
 }
@@ -5535,8 +5535,14 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 
 	data = container_of(ref, struct fixed_file_data, refs);
 
-	/* we can't safely switch from inside this context, punt to wq */
-	queue_work(system_wq, &data->ref_work);
+	/*
+	 * We can't safely switch from inside this context, punt to wq. If
+	 * the table ref is going away, the table is being unregistered.
+	 * Don't queue up the async work for that case, the caller will
+	 * handle it.
+	 */
+	if (!percpu_ref_is_dying(&data->refs))
+		queue_work(system_wq, &data->ref_work);
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,

-- 
Jens Axboe

