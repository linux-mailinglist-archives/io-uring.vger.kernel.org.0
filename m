Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B826059CABF
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 23:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbiHVVVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbiHVVVW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 17:21:22 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B3750719
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:21:21 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id j17so8964350qtp.12
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 14:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc;
        bh=RF5VEJInS+M/9ME7+1NBi/v+S++RwTNIyd06M5yvDic=;
        b=Bzko282c/NA8xtUH43S/BmgiKEOqxZlc/yiGTmIUFKwBF2/CI4U3o3yimKgsdK3OL5
         KepJIP4NU6oFEfrl/HPiHklwqzipd4WdkyqYesfiEprf4U27s8pq5IMpqY4mEn6Yn7Cm
         eVR7m4BZAZfjGcXIgcay/d3zTFyimGyaEaEfTCMADRb+QplAXF4turAC1XrIvwT+lYFs
         QT1oGKmV0VbjHUXcKJk086tY+P+t9Cz0N6AQrh6G6dYxpuMnXFE+vh1OG646SjZ84Zdq
         3lasui8tN5mOiB78AfFiBPDGRmuZuXGiPDajcUJ0wRsckWUBaLEl2UcobDNNLFJE3h5z
         68Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-message-state
         :from:to:cc;
        bh=RF5VEJInS+M/9ME7+1NBi/v+S++RwTNIyd06M5yvDic=;
        b=Hou10KWV8ERMHimWugulN0jIPu38bvYiYqhJGscyPCK0jB9BS0xW8emn1E8ds1V80R
         ScQSZLn017trhdpCJQ1oZzPxfa0G3MKsaJOcIld1prL1yS9Ijb6SMNMoUj7i1823TvwK
         kykLUenqqTnh07LjD8lvScUUe6LJG3uWf8kHxMbLx9PvnNyojko5MOHORCzV6EtxJEHB
         XaZ61USXKQOEX1YcveDg/nCP+N71MRgggS4j5o+OjZG3Dfifg63NBAS2nea8Lm1GLX73
         ZJUV/vjPZQyF4L2iZtlg44PRVPET1hPRq/MvZKQkwhSeCmWt8+aF6l5/IkffYPHPD7Lh
         IkPA==
X-Gm-Message-State: ACgBeo0QO/m/pTN49lkNQyOIpFjuvN/5PYAIeK0681LjAJLz5iGJ2dQI
        X3cTH9Kx8kOTaEMv54NKtRuc
X-Google-Smtp-Source: AA6agR7wCUyNXyYxqoTS06r/xS+GyibVxNaJIowJibrZFTJwbR9zhIgL23Ot9xjTsFbhKMW/+DTKKA==
X-Received: by 2002:ac8:7f47:0:b0:344:8d2b:14a9 with SMTP id g7-20020ac87f47000000b003448d2b14a9mr16667027qtk.442.1661203280736;
        Mon, 22 Aug 2022 14:21:20 -0700 (PDT)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net. [96.237.52.46])
        by smtp.gmail.com with ESMTPSA id w18-20020ac87e92000000b0033a5048464fsm10188122qtj.11.2022.08.22.14.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 14:21:20 -0700 (PDT)
Subject: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Date:   Mon, 22 Aug 2022 17:21:19 -0400
Message-ID: <166120327984.369593.8371751426301540450.stgit@olly>
In-Reply-To: <166120321387.369593.7400426327771894334.stgit@olly>
References: <166120321387.369593.7400426327771894334.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds support for the io_uring command pass through, aka
IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
/dev/null functionality, the implementation is just a simple sink
where commands go to die, but it should be useful for developers who
need a simple IORING_OP_URING_CMD test device that doesn't require
any special hardware.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 drivers/char/mem.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 84ca98ed1dad..32a932a065a6 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -480,6 +480,11 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
 }
 
+static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	return 0;
+}
+
 static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 {
 	size_t written = 0;
@@ -663,6 +668,7 @@ static const struct file_operations null_fops = {
 	.read_iter	= read_iter_null,
 	.write_iter	= write_iter_null,
 	.splice_write	= splice_write_null,
+	.uring_cmd	= uring_cmd_null,
 };
 
 static const struct file_operations __maybe_unused port_fops = {

