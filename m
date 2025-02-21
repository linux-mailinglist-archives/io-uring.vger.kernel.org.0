Return-Path: <io-uring+bounces-6602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 852FDA3F915
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A16D19C3DE2
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031D31CA9C;
	Fri, 21 Feb 2025 15:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8M4c6i2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F9B26AEC;
	Fri, 21 Feb 2025 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740152196; cv=none; b=lDL47pmvTuiRk4bzSQy0+7pb4U6ysJXd789yBhhNYMe7T2puSr1LXNap2zYmcjl/PDjPnBnYfXedGlazBgHw61lqNA/uLBMpBVI7FeYN66stDqVdlfdaCaP5RsBhlk5HDYeqatTo2VvcFH4oU0iKSLc3FVqe9U+Ka3fO+VZn1GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740152196; c=relaxed/simple;
	bh=zXbyACCdVoVQyiGhkcafjf6zWtsGln899zvfTqmUMy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X+Rp/bh+/ZCFfCE+dsAsoOWMxBWpkhpQZ7qPtCot6gpJpV1DEJM9TAJLM/IC6CxLsZTGbi+NKgleZZiJ6HokZBVwO8pZgpRXAhnzhk1nfCeg+drSfRVfuJw4y7CrYNydWjXIMeoPSrHFhSdHKKa3yJu2+eGAlhVZZvOqdtuOhyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8M4c6i2; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3f405bdf7e7so406686b6e.3;
        Fri, 21 Feb 2025 07:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740152193; x=1740756993; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v1yHTvClgL1HOrCrw30baXka1ZGMPkDHp0/uvI9xpJY=;
        b=m8M4c6i2nY1mW6L77vNrs1G6ws3SWi5CbeORLHSqopI8OYehVfmVzBu+owF8MV3Nkz
         0Di2mz6exxtWfxIRhw2MAS+hXl5/wRtnUrWIOv9JEuHGChOXGRCltc+n1NkW7FWeKh+g
         2RMZFVN75ez81OeVLdu1nUG3xXfRgyYPwnW4Ewzs+OI2/J99hrLHKDlUlPbpMqAjdyWN
         6hmFGG6V5o1UdH5ZqhrlpR1fuWIu8dbziztvSOsMnxotfSicgHA7CSmOsd//bX7ob6e6
         wJVTIrO1gOmvzqds/nsabakCu8oRVD9EpU3MSDQs4h/FX0l4wLE2tyFeud61pq5nuDCi
         HT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740152193; x=1740756993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v1yHTvClgL1HOrCrw30baXka1ZGMPkDHp0/uvI9xpJY=;
        b=V5Fnxkg5isYe1OVk+/7fH5J/coVOo6/qPcuezP0sgxaoV5kJxSdaQwBrJDv42xrQoL
         +PkQ9Jn6Jlmmbjs0qC5pxLMrXC5BmqT+QJOf04Pu5aD3iF3yEP+Y+jTSXVLdmuMtDa0D
         UhCXvBYiI5yNsI0vcxT9gTVE4+P7bsPxalFEuVHL17iIBaszqHdgKQ7R90bW3PYBXZY4
         jP6cHBP79UfSe5yJWuBw6OScoNbPilHDzTNFfkWJKOT8gwXGu5tVQ6qtiOyr4QKxvwLq
         AjhI8pe1Ih2fWvM0zA+xmmTtrPPrWey8wWxim+pM2FlMTz4Dazwxu7qR3Jm2v/+iimt7
         4Rkw==
X-Forwarded-Encrypted: i=1; AJvYcCU01FwpmCErpca+yVEiS/BJd0d+ZzSsmlMOa+bitvpxsXErPw8jRx0vnziDuAdqPHLbb+iZPzWqfu61iISwUQ==@vger.kernel.org, AJvYcCVoSipnbPI1oRwQaKV2Z++6dXV7AfBO3sO0cnC2xXhNFw2Rz+j1EW4fWbzq0uJkTLgFKxCs5CuQolTAFHzD@vger.kernel.org, AJvYcCXNxT0hcPntTSUbSKlU0KJAKbj8sQ55VsbCSRLOgRmfbxUzvj+97AVgkjwaChjQ7MVPQeaBhf6rzA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+XkujA59vOYlSVDeCL6O9bdJHVL4CW/Wh5WhpwK510CCf2vjD
	xRYfeBPUwqev+NQkVekoj1+xERZCOfpBc4k5og+e/n0rmUu8ezNO
X-Gm-Gg: ASbGncvYW/sG+N4Jh1/PPsEu946ARgYXf6WKlyZb20nma56oE0Rj/urBQs08C1qr+mV
	pyBTp7HTAo7YXetkRwRcnCi2WH0zX0xVQ8UXY1u9uN1tOvy0dkHXD8cKUGVFIm5hjsVHTn/o2Ss
	ELxwC7Af2iZ/oPJdjtRaJ5Cxem+23nVveMrzgtRd3bwdgDbhMsBM1LmzAT5Tgl7u9J1AbBDaYNF
	Yf1yQngvPTKtYoh7GbehVDJPUOUbsukQ1e8+zRmN4uq2I+dg/IcfjBZPP2wG8qfz0yBaQr+DzHV
	aR9F/z5UfR6RRyyZDTrh67okOVrtvPNeoySCrlUxAp9ms2h4Gz24XpUIOXJMd4+gMXYvvkwLdGt
	T3Vr8ZYHXTS4=
X-Google-Smtp-Source: AGHT+IFFJVL2fg4xBN9j57DjY5+CvBOPQrWPfMGWka5ypcQN2vnYxW2BbNGg+4twdK/FJvrcpTYaTQ==
X-Received: by 2002:a05:6808:1a08:b0:3f4:218:5c8f with SMTP id 5614622812f47-3f4246d7f2fmr2846586b6e.20.1740152193144;
        Fri, 21 Feb 2025 07:36:33 -0800 (PST)
Received: from ?IPV6:2603:8080:1b00:3d:ccc:f28c:f6a1:d9c9? ([2603:8080:1b00:3d:ccc:f28c:f6a1:d9c9])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f3ffd5a695sm2517613b6e.3.2025.02.21.07.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 07:36:32 -0800 (PST)
Message-ID: <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
Date: Fri, 21 Feb 2025 09:36:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
Content-Language: en-US
From: Moinak Bhattacharyya <moinakb001@gmail.com>
In-Reply-To: <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Sorry about that. Correctly-formatted patch follows. Should I send out a 
V2 instead?

Add support for opening and closing backing files in the fuse_uring_cmd 
callback. Store backing_map (for open) and backing_id (for close) in the 
uring_cmd data.
---
  fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
  include/uapi/linux/fuse.h |  6 +++++
  2 files changed, 56 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ebd2931b4f2a..df73d9d7e686 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
      return ent;
  }

+/*
+ * Register new backing file for passthrough, getting backing map from 
URING_CMD data
+ */
+static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
+    unsigned int issue_flags, struct fuse_conn *fc)
+{
+    const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
+    int ret = fuse_backing_open(fc, map);
+
+    if (ret < 0) {
+        return ret;
+    }
+
+    io_uring_cmd_done(cmd, ret, 0, issue_flags);
+    return 0;
+}
+
+/*
+ * Remove file from passthrough tracking, getting backing_id from 
URING_CMD data
+ */
+static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
+    unsigned int issue_flags, struct fuse_conn *fc)
+{
+    const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
+    int ret = fuse_backing_close(fc, *backing_id);
+
+    if (ret < 0) {
+        return ret;
+    }
+
+    io_uring_cmd_done(cmd, ret, 0, issue_flags);
+    return 0;
+}
+
  /*
   * Register header and payload buffer with the kernel and puts the
   * entry as "ready to get fuse requests" on the queue
@@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, 
unsigned int issue_flags)
              return err;
          }
          break;
+    case FUSE_IO_URING_CMD_BACKING_OPEN:
+        err = fuse_uring_backing_open(cmd, issue_flags, fc);
+        if (err) {
+            pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=%d\n",
+                    err);
+            return err;
+        }
+        break;
+    case FUSE_IO_URING_CMD_BACKING_CLOSE:
+        err = fuse_uring_backing_close(cmd, issue_flags, fc);
+        if (err) {
+            pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=%d\n",
+                    err);
+            return err;
+        }
+        break;
      default:
          return -EINVAL;
      }
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5e0eb41d967e..634265da1328 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {

      /* commit fuse request result and fetch next request */
      FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
+
+    /* add new backing file for passthrough */
+    FUSE_IO_URING_CMD_BACKING_OPEN = 3,
+
+    /* remove passthrough file by backing_id */
+    FUSE_IO_URING_CMD_BACKING_CLOSE = 4,
  };

  /**
-- 
2.39.5 (Apple Git-154)


