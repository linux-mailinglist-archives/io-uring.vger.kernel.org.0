Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10837794EE
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbjHKQnk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 12:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbjHKQnk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 12:43:40 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94872D7F
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 09:43:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bdb3ecd20dso1641995ad.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 09:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691772219; x=1692377019;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1WYy5FBsDszxHGWkf47AVZyRC2KbO+g5vsSr54W4dU=;
        b=JlGsWj9cYjQxmqGQrmJVLAL1dl3GfQbg7SCXbAdl55glO1xYpJ+Yh5QKTZq3t5dU3V
         Fs29iXZU/nmvRZZPKj1PZPeJ6AhjTYx+hzSxW2h5tubyiMnLm6BMnx6ztkG9i+6lXP/C
         8Gl37XPaNwb1KyAe7Y/PxcAjS+CA32hNk9vmDbytk4kkv8/S8CAa8wxuwp3khZEvgYSI
         zw67eIs0bY9H80E/Fs+5JhuWdHg6nRVcS4Hu3IynyCdnfmw30YSrBv50VENaPKQFjHQp
         CdGv4Uh0xe6SW221UyrYZMS4RYVqib6mhhVRDGXeGr0jrOtj8SrfC3mv5AD2q2Atj/8h
         ouCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691772219; x=1692377019;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1WYy5FBsDszxHGWkf47AVZyRC2KbO+g5vsSr54W4dU=;
        b=P+WaFgRbqOPmysh3dk2wcUHkTO8acF3A07Xcz35nFZrEQf+qOrN+qPpfz9JYBkdelc
         tiUqCABPdO/dey/7gAvxUifw0QS5UpkSJV2dKlJysQnrjdhTvbl+oqZWPf6kXZHIWBwT
         5RKyQyk6ITY1h+8HQ7mOUi7aWNPYQ+HHMsrsnPZYk+yZnk/xJ9RqkQw4YNJkQ2XlXkiE
         MCg/sa+enL7xFh6u5umwCLIyb9B9CuYvruYUjzIwRms+Bio3CHyt6EqZ2kCVFml090dn
         Qry84FVUk6cfopqbISBnStvDexJqxxJq9lBEsG3CpFvxzsh3y2Ewo7+q3oG6TU9XJczv
         hqUw==
X-Gm-Message-State: AOJu0Yy1nGCCvk+ELZlLSFcyNAr3ZAvgxpWVSj86cCXJwH/Cth4FXboq
        NRSN13SpOj+14pkdlJRPT8sZ2WgLlYsaNO9bsLQ=
X-Google-Smtp-Source: AGHT+IHmEQR6XPf2gCxqS8KkCzCniVx0ioADeLTJgqcoLx4Vlj2xa6eePskeDvnnMQUBHueDdlrYiQ==
X-Received: by 2002:a17:902:d504:b0:1b8:811:b079 with SMTP id b4-20020a170902d50400b001b80811b079mr2980350plg.0.1691772219014;
        Fri, 11 Aug 2023 09:43:39 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d11-20020a170903230b00b001b8af7f632asm4145740plh.176.2023.08.11.09.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 09:43:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d078c0f797322bd01d8c91743d652b734e83e9ba.1691758633.git.asml.silence@gmail.com>
References: <d078c0f797322bd01d8c91743d652b734e83e9ba.1691758633.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing] tests: don't expect multishot recv overflow
 backlogging
Message-Id: <169177221806.198606.5689686263751870786.b4-ty@kernel.dk>
Date:   Fri, 11 Aug 2023 10:43:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 11 Aug 2023 13:58:30 +0100, Pavel Begunkov wrote:
> Multishots may and are likely to complete when there is no space in CQ,
> don't rely on overflows.
> 
> 

Applied, thanks!

[1/1] tests: don't expect multishot recv overflow backlogging
      commit: b73e940c9dd4ffa8ac121db046c0788376691b99

Best regards,
-- 
Jens Axboe



