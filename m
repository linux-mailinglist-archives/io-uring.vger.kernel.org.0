Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE86920C849
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 15:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgF1Nts (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 09:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgF1Nts (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 09:49:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37430C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 06:49:48 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p3so7114960pgh.3
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 06:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mGV7CCXsMX/PFRGvdiVi33g++r1N5t8SlQHxMelPFUY=;
        b=mk1qLE9tFbHJKwsLBn+DnetI/3qPF3fL4qUDDUJ2KJfGC85s8AomEy66ILhVNeXHjO
         cVIIYanzXY7eHfAA8RveH5NjHTUYQj+UWwsS9iZERMR0uP7LZ5jMqhk91YtfDn4sdjBW
         HEl0HtY816SpkhRaS6FWSGcb9AVSnl/HwqQ2K98nR2svPt5XOLCySEN9hoXLxE9MqnSH
         MRdhLvZ+GfK2jW9jfQyNtf7sdW4QwiQIM5hNYPWQnxfkV6SSr+Wn1oBr9/sjpxkiMGiZ
         2LZSi3QO+PZ7vH4JPa05ewPRsUXqPcxmXFBmOpspT5UubaRnAoYf6s2GdWP+lXi6rRkP
         VjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mGV7CCXsMX/PFRGvdiVi33g++r1N5t8SlQHxMelPFUY=;
        b=cvFATasyZk3pbXhdw03PwhhceuZLIxtmN3ipzCV+LxYsEZBzaOB6DhmgQi33IE6Ond
         j5zr4QpjkTO1Q2xTCey4xGeA51a1lxWgD2SHZG46OLVrt3de0xAPNtERROiHp0Zhx46n
         EJJ2PBBiLWc2UfQXYxoWmKHq4zIxT7HhxaRl+St8CWRHz+n01OXSAPgeMI9k78qkRasu
         GLAFk1m6F2ENUAE6VrrPmyl/Mmodl3j6voenQk6f9mrGbrWFj67aap7qKgZHwl9fRIWF
         rlohpAugJXLHq/UugNW0LEr2oF+MwC4MGOzJIxkcHZ5uZTEDgBx/zeS9FZ9gb4OE4lwQ
         29mQ==
X-Gm-Message-State: AOAM5336tOjgykmj/9i4YGoH+VKLM1DCn+Gqcbgjb6ql08DsfsOAB0Xs
        vlPTX3SED1W0QS2LXK8ZOm1Ajj/BD/4oBA==
X-Google-Smtp-Source: ABdhPJwBAGMZNPxrizpWoZz3bDm5gVpDn090bAg0oOpMcb0GKzCDaX24RLyO2PUgeESnVCXYRdWGsQ==
X-Received: by 2002:a63:4e51:: with SMTP id o17mr6849777pgl.315.1593352187313;
        Sun, 28 Jun 2020 06:49:47 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id r17sm4360520pfg.62.2020.06.28.06.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 06:49:46 -0700 (PDT)
Subject: Re: [PATCH 0/5] "task_work for links" fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593253742.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05084aea-c517-4bcf-1e87-5a26033ba8eb@kernel.dk>
Date:   Sun, 28 Jun 2020 07:49:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1593253742.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/20 5:04 AM, Pavel Begunkov wrote:
> All but [3/5] are different segfault fixes for
> c40f63790ec9 ("io_uring: use task_work for links if possible")

Looks reasonable, too bad about the task_work moving out of the
union, but I agree there's no other nice way to avoid this. BTW,
fwiw, I've moved that to the head of the series.

-- 
Jens Axboe

