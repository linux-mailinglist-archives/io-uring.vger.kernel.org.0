Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F75E12D4D0
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 23:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfL3WYe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 17:24:34 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36329 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfL3WYe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 17:24:34 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so18675283pgc.3
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2019 14:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TIrkm/jZBVlDIP9R+ouhSZxem0mIqF7xj7+geN6DVbw=;
        b=FSC4HKH67NDzMTazDmV5EkjoWPZebGPTJyyBE0uPDqyvpforlAoZM9IQw0pTHwBSMa
         fcE4Xa2jhoRpHVdh8GvdUC0sdR2jY1SmVtYnLmSw+QEzPwAHcSRptUjRz/4RjvaySeKk
         yuCJnQNDWcOWjn1QXHK9qn2nrMIxY/n8PaF1bqkwUHt8LI6LlAgkHqV7rlz9eRaKTCWA
         6jhgA5TPmb/W9QtNiDt4r80htikKr+Rn7eXQ37OcwWBZxcHw+g9ONozlWjr0JoY+Wq4V
         skk+70YMDgXXzy6BazQWwSS5raQ0sB47ZuNh4hEXGrKCRy6Us/Sd1JjOEfbPVWmmDZhg
         rVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TIrkm/jZBVlDIP9R+ouhSZxem0mIqF7xj7+geN6DVbw=;
        b=ljJYGnA8qH6gTVZRcVUnumrGZra21Eh347jlg9xzN1HYtdQelaWaI9BLioa5kWXl0r
         TMtu/MJ+v6uicGi9592ma8titDYOmWbMTYGd7B0IWvC9BSwoE8lRCfQ8vu6UxLQHewpe
         4iUpoUTaR8NdBqWIYWtE7Cq39j2EMo8eiNFyAPxGvdQmIXCOv+dG5QB9XV4J51cvw58m
         xwgRh5lTdYmzqnDfm78zMMJAIxBs6KGqmL1Rnbbl4IKmo648XpVDNGYLRdDdSFsxNrZ9
         56W4D9uGw7NfEh7pbcuvcG19wENR5otMWTRHovXRkLElZRACHySZphApBzrjHksP6tvo
         Gx+w==
X-Gm-Message-State: APjAAAU1xeG5PUFV1bU3R3AItnCVTEfg2N5A8cJOY9CAIToKmby1itNi
        R5kp93FS26KbhHUU+56+jfXc1fv8iD0+SQ==
X-Google-Smtp-Source: APXvYqzd6sOOSovIouSfqpNVCLDHO63ek87pGb/j+LPUkTSUFlzgp6BmPQSvfmX5O61HgmBNI+ea1A==
X-Received: by 2002:a63:ea4c:: with SMTP id l12mr72451498pgk.174.1577744673407;
        Mon, 30 Dec 2019 14:24:33 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:a1b2:6e75:661d:3872? ([2605:e000:100e:8c61:a1b2:6e75:661d:3872])
        by smtp.gmail.com with ESMTPSA id c19sm55631094pfc.144.2019.12.30.14.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 14:24:32 -0800 (PST)
Subject: Re: [PATCH 0/4] a bunch of changes for submmission path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1577729827.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a68ec39-4f54-1adc-5e77-2d16c8fc60dc@kernel.dk>
Date:   Mon, 30 Dec 2019 15:24:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cover.1577729827.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/30/19 11:24 AM, Pavel Begunkov wrote:
> This is mostly about batching smp_load_acquire() in io_get_sqring()
> with other minor changes.

These all look good to me, applied.

-- 
Jens Axboe

