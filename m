Return-Path: <io-uring+bounces-6638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB12A40BDA
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 23:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7378D1895B23
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 22:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36231203709;
	Sat, 22 Feb 2025 22:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImNQjV58"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E04120127F;
	Sat, 22 Feb 2025 22:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740263325; cv=none; b=ezdqmrv2WVdxvJ72zogJrnrjiUtxdp71oXJK+SzOq57WZIwoUSUadGn6Tj+GaPAhQQrgsdKXhsasUKy2Ou0U8/3RqjwVrb7n95qyXQcAj9mRr9G6RKdCj8f4DtbeOu+mh2dUbDJLbNExcuMxWXTXeMvCXOAschtSI9sxYwmNqrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740263325; c=relaxed/simple;
	bh=IUNeJ/iSjN3w/nRqQo0U7S6RmezYNxY9tLQkzDKU9mI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=iLhWeOekYe5KJHVKuj6B02K39qy7q/UYGK6ehmdI4RylE8OuvOnXTrSFjEvzAJSc5df8BYQ45bdNQdWwZCjcXl2oiWtuHN1idWuvNEU8UR9FPgv1rJgvChBjfAItVcl2H1xu+OVN/m7hruzUXqZVoKTLqOfu/XkncRw0p/GRDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImNQjV58; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7272f9b4132so2312067a34.0;
        Sat, 22 Feb 2025 14:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740263322; x=1740868122; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZATY+/O1gOePE07bMhnANiNHA/PoOH78EEIsXLV5R8=;
        b=ImNQjV5893bAlp7RrDMKSB/zfz19edQICg8LqDCNyD0kI1jwYuvIARKss1zM/PfD5R
         tSzKlLstBhL1JTQ4KfPBxnbEhU6iXuwVgldDqTZxBdgPUsdPZF9Ff5w8bOM6pKC4xYqR
         HfPvZPZPbFVOE7FuCe5xBAVvsf0BhF0ejlUZS/Zp5j9foSyLY/8Fiz48b8AAMDen8cG8
         JBY4Ldcqz1fKyW2aETs9aiA2iq1c6eY3N7CwLaF84pNbC0lQLFMhjQII4wWbpPnQrwin
         kX2uqceVkOPTUNDtXPUo6m+MxwYubHti4Of6qv/sMvXktkTrcZVzMcBlqK/yX8Koue/1
         kmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740263322; x=1740868122;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CZATY+/O1gOePE07bMhnANiNHA/PoOH78EEIsXLV5R8=;
        b=SpnS14zJ0rfcwXVxGWnRtS6vJZCufIJhhFudQnB8qLUH7WDsWtWlMpeAZppt1CJ8aa
         yh6u2pvM/Y6Sv4bSEzrVzmm+931LmL995WGdUjYf5RL4DIHdhiX3AzlRUXcxsQC4O5Ke
         ZUdvKNdGq8tVdM4bpKu9noIpCnHGsfaENGaYhJrrz5U+bJuL1GwjrdnlNNUGzZuXSD5X
         rAruigZ+ouXUyAvaO8+erlayHPoacp3twKJ0irNxuReuEYFdaq3dhQggEkf4SvkqG4iY
         w60tSH9P6iwRh7cYjNq7dTPahoZMrtx74AOVbuLPSTQW6llSP2O04EWYLPh3lE62DT2j
         Dysw==
X-Forwarded-Encrypted: i=1; AJvYcCUuyuxHs8Wlyqm/fJLN56FfVaJSp6RrzHbEB7nPajMBeOHoEv76arZw+QIMF7IPa/HkbYFwJ5LEGG0i39XOCg==@vger.kernel.org, AJvYcCW9NFxNLImiFtHei+mOt7tZZLuuPxyYIQpAMKOp39esOPXonG2RiSeKEBSoHFOBRcU6ORNS8mX1v/lCUJ3R@vger.kernel.org, AJvYcCWQcMY4bpqabhh6M7zqJqP1k/7wTVYy6U37IHpybwIdQDiAURa5mIslT3HQZs7q3GpeBb9DMpwrdw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7LpuaAqVLko3EJFpBSHZAjR+D+XiqM8gJrJWxf+b/Av4LU0O6
	y3VE4wq0G0xdsVxLKErK+xyJ+ymm1mOzKHTdtgmVB8tU2A1SA3pCg9L4tlTOAsc=
X-Gm-Gg: ASbGncsobt5D7iGczmUlmM8WVv94vrWycRPDpG6juW5PY6fWznAvo++VmRhl+tJ/v2m
	/Dd8K4MTh2Dc0w3/IsLGniqlMdmEVfcreAGUXZRmcs5LB4ZHbGLVt8qXU4XdxwyUKTeMUhrkri3
	KTY1K8bVRFAw1INE6IJG4v7g+takL61tu3+Wf+OIlRWRDBAO9RTXrgJD7A6fLfjiul+fmo0HkS8
	oN3RLccw2G5JZN8MrERxbm5UlapUuujI4IHONSxc7sEmF8OBXAFDGuGwliPLF0eP84emhl3xHT6
	Yvf2rXwkxyPkuvPWf1WGYlv8gkKfY7PM80bYEf+ZslLpifpmpOde0wsk/eRs9kA3jJWEDTjGPl1
	SgT6M0QaB+k8uCA==
X-Google-Smtp-Source: AGHT+IGkqgvYlN3nuulqgQVUumaMYRZ3cpJdYUqTqJZZuVMgCSVogMjmt8fA9f+mJJ8P249v/JR30A==
X-Received: by 2002:a05:6830:448a:b0:727:1033:f55 with SMTP id 46e09a7af769-7274c1d5e8amr6754043a34.13.1740263322417;
        Sat, 22 Feb 2025 14:28:42 -0800 (PST)
Received: from ?IPV6:2603:8080:1b00:3d:9800:76a6:5d39:1458? ([2603:8080:1b00:3d:9800:76a6:5d39:1458])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7272f09f382sm2783210a34.1.2025.02.22.14.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2025 14:28:40 -0800 (PST)
Message-ID: <2cd2a86e-587e-41f8-a3a7-883dd02ac5fe@gmail.com>
Date: Sat, 22 Feb 2025 16:28:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Content-Language: en-US
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bernd@bsbernd.com>
From: Moinak Bhattacharyya <moinakb001@gmail.com>
Subject: [PATCH] fuse: return -EOPNOTSUPP directly from backing_open and
 backing_close when PASSTHROUGH not supported
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Instead of having individual early returns in the ioctl functions, 
create static inline functions that return -EOPNOTSUPP when passthrough 
is not enabled. This will help potentially adding uring_cmd support to 
opening backing files.
---
  fs/fuse/dev.c    |  6 ------
  fs/fuse/fuse_i.h | 13 +++++++++++--
  2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5b5f789b37eb..da1f4e8ed3ea 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2435,9 +2435,6 @@ static long fuse_dev_ioctl_backing_open(struct 
file *file,
         if (!fud)
                 return -EPERM;

-       if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
-               return -EOPNOTSUPP;
-
         if (copy_from_user(&map, argp, sizeof(map)))
                 return -EFAULT;

@@ -2452,9 +2449,6 @@ static long fuse_dev_ioctl_backing_close(struct 
file *file, __u32 __user *argp)
         if (!fud)
                 return -EPERM;

-       if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
-               return -EOPNOTSUPP;
-
         if (get_user(backing_id, argp))
                 return -EFAULT;

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index fee96fe7887b..5cb7ab17ad17 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1485,6 +1485,8 @@ static inline struct fuse_backing 
*fuse_inode_backing_set(struct fuse_inode *fi,
  #ifdef CONFIG_FUSE_PASSTHROUGH
  struct fuse_backing *fuse_backing_get(struct fuse_backing *fb);
  void fuse_backing_put(struct fuse_backing *fb);
+int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map);
+int fuse_backing_close(struct fuse_conn *fc, int backing_id);
  #else

  static inline struct fuse_backing *fuse_backing_get(struct 
fuse_backing *fb)
@@ -1495,12 +1497,19 @@ static inline struct fuse_backing 
*fuse_backing_get(struct fuse_backing *fb)
  static inline void fuse_backing_put(struct fuse_backing *fb)
  {
  }
+
+static inline int fuse_backing_open(struct fuse_conn *fc, struct 
fuse_backing_map *map)
+{
+       return -EOPNOTSUPP;
+}
+static inline int fuse_backing_close(struct fuse_conn *fc, int backing_id)
+{
+       return -EOPNOTSUPP;
+}
  #endif

  void fuse_backing_files_init(struct fuse_conn *fc);
  void fuse_backing_files_free(struct fuse_conn *fc);
-int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map);
-int fuse_backing_close(struct fuse_conn *fc, int backing_id);

  struct fuse_backing *fuse_passthrough_open(struct file *file,
                                            struct inode *inode,
--
2.39.5 (Apple Git-154)

