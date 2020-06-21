Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503D6202C08
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgFUSsM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 14:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgFUSsL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 14:48:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88487C061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 11:48:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y17so6523808plb.8
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 11:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=stdg+m4gQjO1nzcJh0M6j/9qcycsLQkE3xCIqrm3ApQ=;
        b=oBeLzjpV+45funkhd0MCqPYLvkyvZ97yOCOb/I3wBi+j/Ml3kXt3+cc970ZMt1awOe
         aei+3p9sQHhHYfX/i3TGLV3CFvVMwo1+Ik5b9m7LBVXtt2v4ymHCgpWQ4pzBE2C3OKCB
         QvXemwMfxr541xt4zXMpz9e+3lPZrNTboWEbBmyjT5vOGTqlNXI9BYhssQlufbh8Vq3w
         wXJ88GYN85IVE7+Dhdvt1Gfz/E1B89zchUjjJIiDFnjAeKsxmp32E7mTe06wMA9qs5+W
         O4b4gY2+rdsrG0jDrpB9ShU+6U391hT6W7YMoirufo7bqdM9ZZH+uss+wfCUBqt0AB8m
         KNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=stdg+m4gQjO1nzcJh0M6j/9qcycsLQkE3xCIqrm3ApQ=;
        b=YWgK5VWu8tMGePclMRB48al34WFtzxtXc5wCuRu0/CAiXlwx6RIUiPpcrlOS4YxQAD
         5N0XdBMtsFbYsQown0sMeERiGq5lkfgIPs7LRjajPK024fdO/xhqpS8CzFQKC6F8RQ64
         9kwFhYse2F1f8gDgEt1ulWWoKZx1y7yiT8KJ7NlrXzv+K1QCTMo15shzkrMTetc/1NER
         MlueAppicryUVQjzDaztHFnLsmH9YPjeatFGIknMfvKKPHRJaXgXfXsS1G9NVOye/Fge
         RoQMAWfiHh6vK2CaYqs7jSGSBmIDzg9kEaBlMuQouGCzfyaxGuDZeD9D5QAdmGnkL6pk
         LQBw==
X-Gm-Message-State: AOAM531Ll4lk2hDfrmabc63pZUVuJBRzfqACk5c9sElZDomCX0VavbX+
        oK6bSSBUwYGPS52MNTn/NaxfZdHaSPs=
X-Google-Smtp-Source: ABdhPJzcmVLpBOAOnmCyV+Le26BI0CmjeA4uhGvk2qjzlSb5wTZMZ7yJjW0MPwmwrLryVMxgOdtaIw==
X-Received: by 2002:a17:90a:7c48:: with SMTP id e8mr14318233pjl.235.1592765289526;
        Sun, 21 Jun 2020 11:48:09 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m22sm12232560pfk.216.2020.06.21.11.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 11:48:09 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] Fix hang in io_uring_get_cqe() with iopoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1592755912.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c8d6bdd-ff6a-5044-1a5c-c0152f291dc4@kernel.dk>
Date:   Sun, 21 Jun 2020 12:48:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1592755912.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/20 10:14 AM, Pavel Begunkov wrote:
> v2: use relaxed load
>     fix errata
> 
> Pavel Begunkov (2):
>   barriers: add load relaxed
>   Fix hang in io_uring_get_cqe() with iopoll
> 
>  src/include/liburing/barrier.h |  4 ++++
>  src/queue.c                    | 16 +++++++++++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)

After checking again, I think your liburing is quite a bit out-of-date.
Can you check if the issue still exists in the current git tree?

-- 
Jens Axboe

