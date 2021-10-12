Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0927542A7C3
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbhJLPBX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 11:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbhJLPBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 11:01:23 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9406C061570
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 07:59:21 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id h10so14985007ilq.3
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 07:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c/Qx85k3VKm7EowDkBL7+bfMvO5k+TO2uUo+WEpC8hg=;
        b=b1cmgnc5YNvFRimPDV4fAfP++yzYqI+oEBpjhpECo7k8FBPiTfK3UlUTowAcyOariU
         ad2Uhclx3HYKqHYvEwnFsvRdH+k+lGqH4+zZDBfd4geaqh/TlMeq1f8nU0IGTCTGK2du
         UBMLsegRtluiO/hFsHkaS6+yNV3IEB7XEmMcc++bC0UJdGRf3AMjLdi5wHpBLglBPvx6
         ZfG20fwcTEjz16AQBp/uGQYDA6/gN9Ub6MJYr5VDWZdJsfo2lo920fbz+7isvIw0ZPnY
         TmyVPxUkys0yPaEsmXboF49n2Jk2I3jRn7j/HNfEJtSkUPEIdhQfjjawgllqtgMsqnWd
         rAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c/Qx85k3VKm7EowDkBL7+bfMvO5k+TO2uUo+WEpC8hg=;
        b=YmCTU8dF2MZyIpY/KW7mKgxoFseCUl7e3hsu1LeHr7Ynqy3zR82zLAZJSkRTG7EhzI
         0QV7VOw4wIVAYLeFv/kwmVcP2tXWNQlNXFxrgFicxDl42ctowcpHDQ6nbL+kkiY7cf0W
         f1BR+0JZlHgr0aF2R2tvdkm+C3dZXx5L4Qv/+Q6pjn2f4Aj1lmKKNp9r1roJbfLeZkt7
         T583WB7AX+99zd3IRBERuj7eF7r9deBLCMJSQPoEM7quRA2tyzFF+zqFdihmFMt3/B6U
         4ZSbm06XKwPXJQuErm6Y01lQqMMsb0iUClWFIAERFdi/7xrtJIyTKrKSzROtfJNQJL0L
         i9Mw==
X-Gm-Message-State: AOAM530cDDoqa5yRpaRtmnnCftxUwATgh/r5gTPpu8T3kDdVFBhc+Xu2
        nA/7ESfBPPhJ7AZ4ImpK978g+VwaLxnGQw==
X-Google-Smtp-Source: ABdhPJyDXdjbzpLfhPAZaexUp1NkNoqaY09c1TZ3TKQOjKiQ52WyVoO34cpL6CA1Q98D7S5LBFePEQ==
X-Received: by 2002:a05:6e02:158c:: with SMTP id m12mr24027083ilu.64.1634050760912;
        Tue, 12 Oct 2021 07:59:20 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y6sm5737467ilv.57.2021.10.12.07.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:59:20 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: fix io_free_batch_list races
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b1f4df38fbb8f111f52911a02fd418d0283a4e6f.1634047298.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <23dca7fd-54d8-f706-5706-3c77b7e11f09@kernel.dk>
Date:   Tue, 12 Oct 2021 08:59:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b1f4df38fbb8f111f52911a02fd418d0283a4e6f.1634047298.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/21 8:02 AM, Pavel Begunkov wrote:
> [  158.514382] WARNING: CPU: 5 PID: 15251 at fs/io_uring.c:1141 io_free_batch_list+0x269/0x360
> [  158.514426] RIP: 0010:io_free_batch_list+0x269/0x360
> [  158.514437] Call Trace:
> [  158.514440]  __io_submit_flush_completions+0xde/0x180
> [  158.514444]  tctx_task_work+0x14a/0x220
> [  158.514447]  task_work_run+0x64/0xa0
> [  158.514448]  __do_sys_io_uring_enter+0x7c/0x970
> [  158.514450]  __x64_sys_io_uring_enter+0x22/0x30
> [  158.514451]  do_syscall_64+0x43/0x90
> [  158.514453]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> We should not touch request internals including req->comp_list.next
> after putting our ref if it's not final, e.g. we can start freeing
> requests from the free cache.

Applied, thanks.

-- 
Jens Axboe

