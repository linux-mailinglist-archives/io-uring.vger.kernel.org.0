Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E788C3538A5
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhDDPpu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 11:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhDDPpt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 11:45:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D78C061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 08:45:45 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso6730010pji.3
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 08:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cm5OkjpR6CLG4CW1MbbGihDBBI/JssfOqZwgcuKEJtc=;
        b=qW9yo91OPHn7gA85ymTXOLuJb7m4LjFgF0Z+022U9PwW0W27zed0EXF4HRyrDZNUsq
         iuVIwBVdTFBXH+nDwxd1EoMp+HI36cTqIOpRP1ckg8ulRDetjkzn2EGGpJNC7AOGQAxI
         uxABAqOBwiei/D+/TXM7KPHwp4d7Cy2NNZl9T8MA+PFnEQfP9QfOaMjNM/omrtwzR9bJ
         D1vm0B03cy2Vkjzbj+5vnIs/DesWrlBAp0GYnB7UQM9qg0IO9qaRSLcm+QSfCgFkkCk+
         c/ICOtl2uBTf7em83c77hLmlPx1huadhHSU5kryLfuSqjzkcsT5fSQGimuFy1C92l70n
         SvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cm5OkjpR6CLG4CW1MbbGihDBBI/JssfOqZwgcuKEJtc=;
        b=N/t7IXksDvpbHyKc8kioGS/EjJpjtYF6eGkKzoHg9ZfLjENt64pwqgvb//7RhlmUAa
         eMDSRmUYzWCbUJ2OvGKXTkbdaSaRsNHVlfWyKZfzs2bEiro+XkIltrkuyGV5a5e7Ueb5
         adiWdPIJNGGOjKAWSN8+Cfww7zHLywFpLwn9IB7tM44HAf79ryF1ocKQxgaHgaqG77TY
         3SKXh7DZbzO+V2VdjB6MrrVwCq8SoAFa7uzzR886VgnGa8yJGfo78cLcg61A/cRJuwH7
         9jr5FpxhYXENbxBEzeNRErSifWxeVM/Xv6pC32AH9gHBSCDJFyfTIkgbYFnFxFx285eS
         rGBg==
X-Gm-Message-State: AOAM532S4JKF0ru1nB35cTyC1M90u1Zv9YZexPFAKsWFCEl/0li1l75Q
        RfPaUYuZuaAyk6X0hARaeDOi0xxOuUa1hg==
X-Google-Smtp-Source: ABdhPJxHR1pYHkuNY3cjnSG98HowdOtNnyA0xah8PpYER7NaIzTS6muUQ/ooXuK3X1nPC2f0eJaBVg==
X-Received: by 2002:a17:90b:3718:: with SMTP id mg24mr2190137pjb.164.1617551144590;
        Sun, 04 Apr 2021 08:45:44 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d20sm13118286pjv.47.2021.04.04.08.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 08:45:44 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: test CQE ordering on early submission
 fail
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <bfc0ffac5d54adeb3472ec6160f6aeaf8f70c1ca.1617099951.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7700fae5-20ab-d368-2383-d0eddf3a5320@kernel.dk>
Date:   Sun, 4 Apr 2021 09:45:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bfc0ffac5d54adeb3472ec6160f6aeaf8f70c1ca.1617099951.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/21 4:26 AM, Pavel Begunkov wrote:
> Check that CQEs of a link comes in the order of submission, even when
> a link fails early during submission initial prep.

Applied, thanks.

-- 
Jens Axboe

