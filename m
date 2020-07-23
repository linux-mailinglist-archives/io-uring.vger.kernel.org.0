Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84FC22B596
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgGWSYD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 14:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgGWSYD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 14:24:03 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CEDC0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:24:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mn17so3555071pjb.4
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yRZLrqy+JUyMtB3P44jbDEwmeRAH5OMon1tzDQ5Bs+E=;
        b=nE0MSmpr2zzl19VZLQtBL/w+GX81HMCyjsTQ2lm6AeO7WD/nkQZUPvjlGOA6Omhdei
         lfA4tVfKYSBEmfLff032X1VPfC3L3XoxVBa/VlG5dC31EjnkpFZcQSOV/PPpc3+0r62T
         /h8bKD7GylxXwnimi8JVvFHTJC6uSovp1JBfLSzehbLywOCwL7/5TOnuqRA2t6yTodFT
         jQtsabcXJ14koadCzafRw/2UK4kIdAarcd4m8a/dXAhMKrnH4JNCxmSJQSHDuHqI8szA
         +aZO8HKkq3miodMuWrkHdRz/5tnfqWuOO+zf/2JJqZq+D9tXIl96ZR6cza1JynZAjMnR
         pasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yRZLrqy+JUyMtB3P44jbDEwmeRAH5OMon1tzDQ5Bs+E=;
        b=laB4Xm24LHm10iohh4Lzsk6/eDH09+Gghxc9DV3F1KY6jWBKfivrAOU0r+uT+b2jSE
         07fiKjV6C3qPoCi7Ezp+EUCY+6wgdv7h17mQWkCIjClW73hBXErS5UKMD2+uPLYOAB2w
         +P37WqwzuMY3AywuPziqMy9K3C4oSyCMvh7x9+h6f4TsHGJYal+UUHEXGGKrZ5tsnOwB
         IyD/VqRpx/9vy6b3ao3/Xksgh5fjkBlS5zcsLDamNOI7pqKrswzDdMXQQ9sP6l+lIvhC
         bu8zInqg0LlkNd42g9gY97mfrfITVDyGVRPh4hQHuoqx2iZmA+NTUYBEt7o3GOmaQRIH
         Wycg==
X-Gm-Message-State: AOAM530fc2F60v1oCMQ5B60CXGUEijYghWC7B9YvMRlaM9CvYbl6Jol4
        Q6V8F7CVaKWEhR3mFx9DlhDp4d1E05fxVw==
X-Google-Smtp-Source: ABdhPJxp7ct0/UvyuZkY5eil8qQymoblawbbQkhSw4bc81jzbqYO9EDu+KCtLVhLS6QKVn9D+dBuuA==
X-Received: by 2002:a17:902:8681:: with SMTP id g1mr4950437plo.303.1595528642291;
        Thu, 23 Jul 2020 11:24:02 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q24sm3707297pfg.95.2020.07.23.11.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 11:24:01 -0700 (PDT)
Subject: Re: [PATCH 0/2] prep and grab_files cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595524787.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9f9df17f-8890-5219-b153-c17583e7f342@kernel.dk>
Date:   Thu, 23 Jul 2020 12:24:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1595524787.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/20 11:25 AM, Pavel Begunkov wrote:
> Not sure we currently have a problem mentioned in [1/1],
> but it definitely nice to have such a guarantee.

I think better safe than sorry, and it doesn't impact the fast path.

I've applied the series, thanks.

-- 
Jens Axboe

