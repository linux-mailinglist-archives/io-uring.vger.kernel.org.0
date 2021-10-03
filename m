Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F03420228
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 17:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJCPQA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 11:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhJCPP7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 11:15:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC2AC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 08:14:11 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r201so8272038pgr.4
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 08:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dO8+me33OQdO5JcDqfJ9CX+0sEH7weTZ1dVoIA88HgI=;
        b=gQCI3/9ax+g9bEM0jZY/1LX/I4IKzKnshqbOVbOVmOKI+4/z9u5CyPhXxGPKHDnMXV
         SbTg8fO9BLNV5qfTVDRe0YF/frDJFA8sQnjSckkuXGBW63qOJ7LFDJn+4sC4++HBsnHX
         Su4CboLJiTWLCzWrjQFf6/xZIiSjDNbQVNRIIElSA7CI7IXLBHV3PETON2IhMecgZ5Kd
         APmYGKNRC7/QWmsWtzdHjqo9Ch/z9Wwb84FvQYeolHaUxTgjHG7bWXV/kNDLek9xLuTl
         +kbMgV2YX10gV/STMS7sO5yKNHTiytaF/72t12ZmG5E24owhBE/46JYRARiNH+QSpsjx
         avuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dO8+me33OQdO5JcDqfJ9CX+0sEH7weTZ1dVoIA88HgI=;
        b=S/CDonNIaqNLj13RNXUyhf4sVxr7Tl7tr6J+BXYTeH/b5GXtuO1EKfEb+GLs7QOMTD
         nqJRXIqeeg7EFpxCkLkIJe2F13GrKum4esbYD5F4PSchTBFpCmjUk540b4FheobkSx37
         MBsGsziHc3S6tzGWr+kfHBn1G2kGCsqffik5phx3dYouY4Q0FLA7phoxX7GcaC3e9/5r
         qm+Am/RTjuIYU3hAw6YSy28K5OIX2AnY7SJxcg6O8mxpw9dzehKDIXqUgBQkAaNdVIox
         geDv3SGEWdO90Wrqf92/NfKeb6BBGBSnoYG1Hh5FkpmX7KT1wpfX9r7K7kv1zyTJZlK1
         WvPA==
X-Gm-Message-State: AOAM530WRv12hRAXoM74SljuqGnAnDX7ECKlW9agWry8sH8KEsnN3Ox7
        kpdIjmAoukV9a4O8dBsVRWa49A==
X-Google-Smtp-Source: ABdhPJyaffBc8eOI42ZBZ2dBMgnDUZGpc7Lo1v8ODvPhZraauM/ZkOhujn5zx3KejV6AgSONvuJpBg==
X-Received: by 2002:a05:6a00:98e:b0:44b:fa98:6c93 with SMTP id u14-20020a056a00098e00b0044bfa986c93mr18168138pfg.14.1633274051121;
        Sun, 03 Oct 2021 08:14:11 -0700 (PDT)
Received: from integral.. ([182.2.73.133])
        by smtp.gmail.com with ESMTPSA id m7sm11197140pgn.32.2021.10.03.08.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 08:14:10 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: Re: [PATCH v4 RFC liburing 3/3] Wrap all syscalls in a kernel style return value
Date:   Sun,  3 Oct 2021 22:13:38 +0700
Message-Id: <20211003151338.348626-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2f6be7db-5764-8a48-ccbd-4a49f522eae2@kernel.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Oct 3, 2021 at 8:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>> diff --git a/src/register.c b/src/register.c
>> index cb09dea..fec144d 100644
>> --- a/src/register.c
>> +++ b/src/register.c
>> @@ -6,7 +6,6 @@
>>  #include <sys/mman.h>
>>  #include <sys/resource.h>
>>  #include <unistd.h>
>> -#include <errno.h>
>>  #include <string.h>
>>  
>>  #include "liburing/compat.h"
>> @@ -104,13 +103,16 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
>>  
>>  static int increase_rlimit_nofile(unsigned nr)
>>  {
>> +	int ret;
>>  	struct rlimit rlim;
>>  
>> -	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
>> -		return -errno;
>> +	ret = uring_getrlimit(RLIMIT_NOFILE, &rlim);
>> +	if (ret < 0)
>> +		return ret;
>> +
>>  	if (rlim.rlim_cur < nr) {
>>  		rlim.rlim_cur += nr;
>> -		setrlimit(RLIMIT_NOFILE, &rlim);
>> +		return uring_setrlimit(RLIMIT_NOFILE, &rlim);
>>  	}
>
>This isn't a functionally equivalent transformation, and it's
>purposefully not returning failure to increase. It may still succeed if
>we fail here, relying on failure later for the actual operation that
>needs an increase in files.
>
>> diff --git a/src/syscall.h b/src/syscall.h
>> index f7f63aa..3e964ed 100644
>> --- a/src/syscall.h
>> +++ b/src/syscall.h
>> @@ -4,11 +4,15 @@
>>  
>>  #include <errno.h>
>>  #include <signal.h>
>> +#include <stdint.h>
>>  #include <unistd.h>
>> +#include <stdbool.h>
>>  #include <sys/mman.h>
>>  #include <sys/syscall.h>
>>  #include <sys/resource.h>
>>  
>> +#include <liburing.h>
>> +
>>  #ifdef __alpha__
>>  /*
>>   * alpha and mips are exception, other architectures have
>> @@ -60,6 +64,21 @@ int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
>>  			    unsigned int nr_args);
>>  
>>  
>> +static inline void *ERR_PTR(intptr_t n)
>> +{
>> +	return (void *) n;
>> +}
>> +
>> +
>
>Extra newline here.
>
>Apart from those two, starting to look pretty reasonable.
>
>-- 
>Jens Axboe
>

Thanks for the review, I will address those two and send the v5 of
this series.

-- 
Ammar Faizi
