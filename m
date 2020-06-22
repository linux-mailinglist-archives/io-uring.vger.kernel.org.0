Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEFA202E82
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgFVCur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 22:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgFVCuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 22:50:46 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969F7C061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 19:50:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so7498169pge.12
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 19:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7jB6xbu7QTe+6XWdZNrUG4tChL7/R7LWiT564nwfdxg=;
        b=joeFJ4jJo3aHYYdkNXE90Ng4PIneyKXzeuP9yWYxXqrK4OfjJ6jjPRhO33u8YqTAbJ
         xHBwhWhHO5S0ABxSLjOOcibGb4hjbHDGOe5IKdUS6gp0Hb2qR81kjiFWS8DOLLdK8yjJ
         VRnDFyXylNsjjc/nd4ccrVnE0OKQmbncLAHsEAO6rbq0An+0uj7pIGE9+BcttsafmBF5
         wedkeLvFfGDHLWOfL7pNerxcGlQWLb4v0ga5QmyCIbMozY9moN7wiZzCtryphPbOnSS9
         bcOE8RH1cjlNJQqthlhO3sJ2cc+sBsVBcwQz3TfXLrowJyDC94q17sNz27N0S1QKXKaO
         /omA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7jB6xbu7QTe+6XWdZNrUG4tChL7/R7LWiT564nwfdxg=;
        b=NOVOMf/THS6GnuAnfvXbQk1YDmXzycMUzh9LCRYRy0vkQvhS5pN1ByERvt4Ss8OCMd
         HJr3z/bFE7/YLpDMU+VTirdlDmyMS3R6WtfSXXoxpcvyBkTo1T/lZk6idytqNlkEUoc/
         RKtRRyRrj6ZYVijqbGbtW8QOimc+IeEUmVtCSQFyeG8iElcK98xwvps7kvQFOKUdUPjs
         sl9kwj7fs/fiOgEtd4azeF0pvMuQTW2wNqVA00XJVBGAqQ8WdHIkyTKK/GYHLRNLN5f9
         ZFEWsmwOnAq0rGW0vcjmTnVqUZbWLThLBrOiETs+NJ1O/95n/BNK9b0SS6+OkXa3lahX
         ptqQ==
X-Gm-Message-State: AOAM531Ye4c2Tw7MYT/Szvat0GRtFDxfrhocUioiagGBHXMJvxD0PLDY
        8L0IuCWMcgxSrX1TGBTt+asx2vg7r7k=
X-Google-Smtp-Source: ABdhPJzzwqj8yCo5TWYaDzmnqArFlyMFvuzGn9zmLC3NlV6kkSpe7vANxLJMyNezq1X1wdFh+1rq8A==
X-Received: by 2002:aa7:9a5d:: with SMTP id x29mr17696155pfj.65.1592794245734;
        Sun, 21 Jun 2020 19:50:45 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u35sm9547796pgm.48.2020.06.21.19.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 19:50:45 -0700 (PDT)
Subject: Re: [PATCH liburing 0/3] Three small liburing patches
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     io-uring@vger.kernel.org
References: <20200621203646.14416-1-bvanassche@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <51509c5f-359b-5fad-86d3-645719662076@kernel.dk>
Date:   Sun, 21 Jun 2020 20:50:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200621203646.14416-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/20 2:36 PM, Bart Van Assche wrote:
> Hi Jens,
> 
> The changes in this patch series are as follows:
> - Enable additional compiler warnings, similar to W=1 for kernel code.
> - Simplify the barrier.h header file.
> - Convert a macro into an inline function to allow compilers to produce
>   better diagnostics.
> 
> Please consider this patch series for the official liburing repository.

Thanks, applied.

-- 
Jens Axboe

