Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD14016EF25
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 20:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgBYTiJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 14:38:09 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38194 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgBYTiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 14:38:09 -0500
Received: by mail-pl1-f194.google.com with SMTP id p7so214661pli.5
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 11:38:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MruP3QPfGdGYmFeFxgNT/R6RU8rXqKgrk/M2lAOnh58=;
        b=robgPEssfjAKhUHqRuYZ5gVRyVWxsu2XtKo92X3VT0EpUIZDPBi1pVqn7WWkdRdGfU
         RL12GDzpjo0wpsCoiSs4GIFlMtRe/xGRv5bCfN53O322dSa3SG2ZtHOHf+BxzMfKYfEI
         d108LT9jNATMzV5AeVFr+P8jg2xcTu+scKUiFPczbLDJPZYFkvobYcqH+kGJJ03ztyUk
         TwdbxjW5pLa9yVNceVM201yrQ/OXkG1i4VzWxrdtxsUjzKkV0FsbSbSe+I6qEIfzSmj1
         RPSAnYdAh3HxkMb9nMK/BQSm8nN++ATCuF46AGxKyDciZx43IBLMic+qZJSeoVIh+M6K
         HHHg==
X-Gm-Message-State: APjAAAVpZtJNTRChH/hgfDNV7SFtUC1THWwfDqpg6nFuUtKII4eLYrlL
        potTe1glcth99W8h3e4BgwHKwMkN
X-Google-Smtp-Source: APXvYqzGO9wFiq37UMhqpwmZCbB8nl4JL/X6rvfPhb7EP1TivQm5kS3qUpLvjgCfcL+q0F6rtiV2PQ==
X-Received: by 2002:a17:902:7048:: with SMTP id h8mr146422plt.64.1582659488216;
        Tue, 25 Feb 2020 11:38:08 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p24sm17889473pff.69.2020.02.25.11.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 11:38:07 -0800 (PST)
Subject: Re: [PATCH] io-wq: ensure work->task_pid is cleared on init
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c3ae0a5d-0557-cdaf-b38e-9d47605c2347@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <78cb95d8-781f-3046-e161-4bb2a2ca3622@acm.org>
Date:   Tue, 25 Feb 2020 11:38:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c3ae0a5d-0557-cdaf-b38e-9d47605c2347@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 10:55 AM, Jens Axboe wrote:
> We use ->task_pid for exit cancellation, but we need to ensure it's
> cleared to zero for io_req_work_grab_env() to do the right thing.

How about initializing .task_pid with this (totally untested) patch?

diff --git a/fs/io-wq.h b/fs/io-wq.h
index ccc7d84af57d..b8d3287cec57 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -80,15 +80,7 @@ struct io_wq_work {
  };

  #define INIT_IO_WORK(work, _func)			\
-	do {						\
-		(work)->list.next = NULL;		\
-		(work)->func = _func;			\
-		(work)->files = NULL;			\
-		(work)->mm = NULL;			\
-		(work)->creds = NULL;			\
-		(work)->fs = NULL;			\
-		(work)->flags = 0;			\
-	} while (0)					\
+	do { *(work) = (struct io_wq_work){ .func = _func }; } while (0)

  typedef void (get_work_fn)(struct io_wq_work *);
  typedef void (put_work_fn)(struct io_wq_work *);

Thanks,

Bart.
