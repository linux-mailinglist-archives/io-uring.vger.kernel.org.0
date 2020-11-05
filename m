Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1AF2A8404
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 17:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbgKEQwc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 11:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgKEQwb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 11:52:31 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CB6C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 08:52:31 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r9so2480949ioo.7
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 08:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=iSeO1J6oE3zkb2zcaq6pXPmcv9enyU7gdMJS58/NGFc=;
        b=yS+gT4SK6lvU04ow7Cx+gWDKHfAYiBw382r2DmwUD6oHpcpBCFJzRHzazLnc+gRyyY
         y7el1krJ1vtxd+1pXSgpbZahHMsnWzpDpTYQ2VAJLIeAYZopqAUxC9hT5U8PgvvZYhSg
         HoRQZYi0s7IqgfQtsXu8eVgj3lgENis99aXR2o0AoMFnUj5q4cgjq3nDa2OCJo/GzGq1
         RdmY24CNYPz5w8jbryX1o7Fvq83m8x4a+twj7q/tcDxoUbGArHfrQ9YHm5Kmv0C7RrjH
         VCz+IZHSjywEj51bJy2EGBZrDAGglphGLxV9N5kstWgNT3i4Z8LawPwJzJ7x6ldof1wt
         2W8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=iSeO1J6oE3zkb2zcaq6pXPmcv9enyU7gdMJS58/NGFc=;
        b=jrCnltHFqm4mwORl3NHVUONMsF7EpywHaGnuIrYhsWiAkjMM7nn2ZY1qXOpwiUaik4
         PZY43BybqKIcvoNQBGUnWaPaojq6pd+ARFkjic+smVVFMoD0dbxMLbPthkR3uDJcyQG2
         BQvj9PNdOkP7Q+jMM6YOoUX7f0sKtUSxoUZY0PNpawPhmdvNsycn2+2q2/c+WQwIWk+r
         1+cAl4EVuKFa5qfzknF3yNUvY+qhFxdAi/HkBXaI6aMBO98E3OUjEFaeiFsdawDxOgkk
         A/Czly+xDC3FRqYvMinpl2lTcBzw/rbm4qqvWzkCX0Sbf+SRs0bY0OLe7wx6XWaBxofQ
         sfSQ==
X-Gm-Message-State: AOAM533AOOhICvNDI0JGptMhm0nGoD1I5OLAplexZdd0sAXTSee6dxmb
        rnAUgZuC0OgZvKARQhL/FLdL6dZ37DzU1g==
X-Google-Smtp-Source: ABdhPJyfdyWXgsFK+zFXnG8fOJjqW0yW7202xR2H4c8vQozJ1ovscLfXbTuELemCPaBeJcCzWDPvlw==
X-Received: by 2002:a02:cc84:: with SMTP id s4mr1018379jap.126.1604595150936;
        Thu, 05 Nov 2020 08:52:30 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a1sm1354286iod.39.2020.11.05.08.52.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 08:52:30 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: use correct pointer for io_uring_show_cred()
Message-ID: <87ad2150-609f-3b42-84a9-22873e6b2d6d@kernel.dk>
Date:   Thu, 5 Nov 2020 09:52:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Previous commit changed how we index the registered credentials, but
neglected to update one spot that is used when the personalities are
iterated through ->show_fdinfo(). Ensure we use the right struct type
for the iteration.

Reported-by: syzbot+a6d494688cdb797bdfce@syzkaller.appspotmail.com
Fixes: 1e6fa5216a0e ("io_uring: COW io_identity on mismatch")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d489cf31926..29f1417690d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8974,7 +8974,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 #ifdef CONFIG_PROC_FS
 static int io_uring_show_cred(int id, void *p, void *data)
 {
-	const struct cred *cred = p;
+	struct io_identity *iod = p;
+	const struct cred *cred = iod->creds;
 	struct seq_file *m = data;
 	struct user_namespace *uns = seq_user_ns(m);
 	struct group_info *gi;

-- 
Jens Axboe

